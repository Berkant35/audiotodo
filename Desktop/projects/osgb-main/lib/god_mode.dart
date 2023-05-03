import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/network/auth/auth_manager.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/main.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/components/input_form_field.dart';
import 'package:osgb/utilities/constants/app/enums.dart';

import 'models/inspection.dart';
import 'models/search_user.dart';

class GodMode extends ConsumerStatefulWidget {
  const GodMode({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _GodModeState();
}

class _GodModeState extends ConsumerState<GodMode> {
  late TextEditingController adminEmailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    adminEmailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          var db = ref.read(currentAdminWorksState.notifier).fb.dbBase;
          db.collection("inspections").get().then((value){
            var snapshots = value.docs;

            for (var perSnapshot in snapshots) {
              var perInspection = Inspection.fromJson(perSnapshot.data());
              perInspection.createdDate = DateTime.now().toString().substring(0,16);
              perInspection.updatedDate = DateTime.now().toString().substring(0,16);


              db.collection("inspections").doc(perInspection.inspectionID).set(perInspection.toJson());
            }

          });
        }
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          CustomFormField(
              authEditingFormController: adminEmailController,
              validateFunction: (value) => null),
          CustomFormField(
              authEditingFormController: passwordController,
              validateFunction: (value) => null),
          CustomElevatedButton(
              onPressed: () {
                //expert List
                //ref.read(currentAdminWorksState.notifier).getExpertList(ref);
                //admin
                ref.read(currentRole.notifier).createUserWithEmailAndPassword(
                    adminEmailController.text,
                    passwordController.text,
                    null,
                    Roles.admin,
                    SearchUser(
                        userName: "Admin",
                        role: "Admin",
                        typeOfUser: "Admin",
                        rootUserID: "Admin"));
              },
              inButtonText: "Admin Ekle")
        ],
      ),
    );
  }
}
