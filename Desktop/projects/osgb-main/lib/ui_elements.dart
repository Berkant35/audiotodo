import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/utilities/components/custom_card.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/components/input_form_field.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:osgb/utilities/init/navigation/navigation_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UIElements extends ConsumerStatefulWidget {
  const UIElements({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _UIElementsState();
}

class _UIElementsState extends ConsumerState<UIElements> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CustomElevatedButton(
              onPressed: () {},
              inButtonText: "İŞLEMİ BİTİR",
              primaryColor: MaterialStateProperty.all(Colors.orange),
            ),
          ),

          CustomFormField(
            authEditingFormController: TextEditingController(),
            validateFunction: (String? value) {},
          ),
          CustomFormField(
            authEditingFormController: TextEditingController(),
            validateFunction: (String? value) {},
            maxLength: 5,
          ),
        ],
      ),
    );
  }
}
