import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/line/global_providers.dart';
import 'package:kumas_topu/ui/main_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'auth/login_page.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  bool anyHasToken = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initPackageInfo(ref);
    //ref.read(rfidStateProvider.notifier).initReader(ref);
    ref.read(viewModelStateProvider.notifier).checkToken().then((value) {
      anyHasToken = value;
      isLoading = false;
      setState(() {});
    });
    ref.read(rfidStateProvider.notifier).initReader(ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : anyHasToken
              ? const MainPage()
              : const LoginPage(),
    );
  }

  Future<void> _initPackageInfo(WidgetRef ref) async {
    PackageInfo _packageInfo = PackageInfo(
      appName: 'Unknown',
      packageName: 'Unknown',
      version: 'Unknown',
      buildNumber: 'Unknown',
      buildSignature: 'Unknown',
      installerStore: 'Unknown',
    );
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
      final deviceVersion = int.parse(_packageInfo.version.replaceAll(".", ""));
      ref
          .read(currentVersionProvider.notifier)
          .getVersionAndSet()
          .then((value) {
        if (ref.read(currentVersionProvider) != null) {
          final serverAppVersion = int.parse(ref
              .read(currentVersionProvider)!
              .data!
              .appVersion!
              .replaceAll(".", ""));


          if (serverAppVersion != deviceVersion)
          {
            final downloadUrl = Uri.parse("https://www.kumastopu.com/apk/app-release.apk");
           AwesomeDialog(
                context: ref.context,
                dialogType: DialogType.info,
                dismissOnTouchOutside: false,
                animType: AnimType.bottomSlide,
                title: "Yeni Versiyon Tespit Edildi",
                desc: "Yeni versiyon yüklemesi için tamam'a basınız",
                btnOkText: "Tamam",
                btnOkOnPress: ()=>launchUrl(downloadUrl,mode: LaunchMode.externalApplication)
            ).show();
          }
        } else {
          throw Exception("Null Server App Version");
        }
      });
    });
  }
}
