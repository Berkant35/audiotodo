import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utilities/init/theme/custom_colors.dart';

class AcceptPolicy extends ConsumerStatefulWidget {
  final bool isAccept;
  final Function(bool) onChanged;

  const AcceptPolicy(
      {Key? key, required this.onChanged, required this.isAccept})
      : super(key: key);

  @override
  ConsumerState createState() => _AcceptPolicyState();
}

class _AcceptPolicyState extends ConsumerState<AcceptPolicy> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: widget.isAccept,
            activeColor: CustomColors.primaryColor,
            onChanged: (value) => widget.onChanged(value!)),
        GestureDetector(
          onTap: () {
            try{
              launchUrl(
                  Uri.parse("https://osgb.linksible.com/gizlilik-sozlesmesi.html"),
                  mode: LaunchMode.inAppWebView
              );
            }catch(e){
              debugPrint('$e<-err');
            }
          },
          child: Text(
            "Gizlilik Politikalarını kabul ediyorum",
            style: ThemeValueExtension.subtitle2.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        )
      ],
    );
  }
}
