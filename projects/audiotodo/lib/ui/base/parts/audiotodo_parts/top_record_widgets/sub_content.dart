import 'package:audiotodo/utilities/constants/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/custom_colors.dart';

class SubContent extends ConsumerStatefulWidget {
  const SubContent({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SubContentState();
}

class _SubContentState extends ConsumerState<SubContent> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, widgetRef, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(flex: 2, child: colInfo("Salı","16.00")),
            const Expanded(
                flex: 1,
                child: Icon(
                  Icons.access_alarm_outlined,
                  color: CustomColors.greyColor,
                )
            ),
            Expanded(flex: 2, child: colInfo("Tarih","14.05.2023")),

          ],
        );
      },
    );
  }

  Column colInfo(String title, String content) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title,style: ThemeValueExtension.subtitle2.copyWith(
          color: CustomColors.textGreyColor
        ),),
        Text(content,style: ThemeValueExtension.subtitle.copyWith(
            color: CustomColors.fillBlackElevationColor,

        )),
      ],
    );
  }
}
