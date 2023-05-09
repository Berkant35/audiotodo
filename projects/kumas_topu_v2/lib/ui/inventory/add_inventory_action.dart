import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/line/global_providers.dart';
import 'package:kumas_topu/utilities/components/custom_elevated_button.dart';
import 'package:kumas_topu/utilities/components/row_form_field.dart';
import 'package:kumas_topu/utilities/constants/app/enums.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../utilities/constants/extension/context_extensions.dart';
import '../../utilities/init/theme/custom_colors.dart';

class AddInventoryAction extends ConsumerStatefulWidget {
  final bool isShipment;

  const AddInventoryAction({
    Key? key,
    required this.isShipment
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddInventoryActionState();
}

class _AddInventoryActionState extends ConsumerState<AddInventoryAction> {
  late TextEditingController titleController;
  final titleKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sayım Oluştur',
          style: ThemeValueExtension.headline6
              .copyWith(fontWeight: FontWeight.bold)),
      insetPadding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 1.w),
      content: SingleChildScrollView(
        child: Form(
          key: titleKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RowFormField(
                  headerName: "Sayım Başlık",
                  hintText: "Sayım-1",
                  maxLength: 100,
                  prefixIcon: Icons.drive_file_rename_outline,
                  editingController: titleController,
                  custValidateFunction: (value) =>
                      (value != null && value != "")
                          ? null
                          : "Boş bırakılamaz"),
              SizedBox(
                height: 2.h,
              ),
              ref.watch(loginButtonStateProvider) != LoadingStates.loading
                  ? CustomElevatedButton(
                      onPressed: () {

                        titleKey.currentState!.save();
                        if (titleKey.currentState!.validate()) {
                          ref
                              .read(viewModelStateProvider.notifier)
                              .addInventory(ref, titleController.text,ref.read(currentIsShipmentProvider))
                              .then((value) {
                                if(value){
                                  NavigationService.instance.navigatePopUp();
                                }
                          });
                        }
                      },
                      inButtonText: "Oluştur",
                      primaryColor: CustomColors.primaryColorM)
                  : const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
