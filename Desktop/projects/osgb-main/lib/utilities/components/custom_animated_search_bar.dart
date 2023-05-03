import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/utilities/init/theme/custom_colors.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class CustomAnimatedSearchBar extends ConsumerStatefulWidget {
  const CustomAnimatedSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CustomAnimatedSearchBarState();
}

class _CustomAnimatedSearchBarState
    extends ConsumerState<CustomAnimatedSearchBar> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    ref.read(currentSearchText.notifier).addController(textEditingController);

  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: 5.h,right: 2.h),
      child: AnimSearchBar(
          width: 90.w,
          rtl: true,
          searchIconColor: Colors.white,
          color: CustomColors.primaryColor,
          textController: textEditingController,
          onSuffixTap: () {},
          boxShadow: true,
          helpText: "Şirket İsmi Ara",
          animationDurationInMilli: 500,
          autoFocus: false,
          onSubmitted: (value) {},
          suffixIcon: const Icon(Icons.cancel_outlined,color: Colors.white,),
      ),
    );
  }
}
