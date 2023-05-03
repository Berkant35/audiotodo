

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';

class CustomDialogs {
  static void deleteConsumer(WidgetRef ref,String rootUserID) {
    final deleteAwesomeDialog = AwesomeDialog(
        context: ref.context,
        dialogType: DialogType.warning,
        title: "Müşteri Sil",
        desc: "Müşteri Sil",
        body: Text("Bu işlemi yapmaktan emin misiniz?",style: ThemeValueExtension.subtitle,),
        btnOkText: "Sil",
        btnCancelText: "Vazgeç",
        btnCancelOnPress: (){},
        btnOkOnPress: (){
          ref.read(currentButtonLoadingState.notifier).changeState(LoadingStates.loading);
          ref.read(currentAdminWorksState.notifier).deleteCustomer(rootUserID, ref);
        }
    );
    deleteAwesomeDialog.show();
  }
}