import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/models/inspection.dart';
import 'package:osgb/models/wait_fix.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';

class CurrentInspectionManager extends StateNotifier<Inspection?> {
  CurrentInspectionManager(Inspection? state) : super(null);

  void changeCurrentInspection(Inspection inspection) {
    state = inspection;
  }

  void addWaitFix(WaitFix waitFix) {
    state!.waitFixList!.add(waitFix);
    var inspection = Inspection(
      inspectionID: state!.inspectionID,
      customerID: state!.customerID,
      customerName: state!.customerName,
      doctorID: state!.doctorID,
      expertID: state!.expertID,
      inspectionIsStarted: state!.inspectionIsStarted,
      inspectionIsDone: state!.inspectionIsDone,
      inspectionExplain: state!.inspectionExplain,
      inspectionDate: state!.inspectionDate,
      createdDate: state!.createdDate ?? DateTime.now().toString().substring(0,16),
      updatedDate:  DateTime.now().toString().substring(0,16),
      doctorName: state!.doctorName,
      waitFixList: state!.waitFixList,
      lowDanger: state!.lowDanger! +
          ((getKeyForDangerInspections(waitFix.waitFixDegree!) == "lowDanger")
              ? 1
              : 0),
      normalDanger: state!.normalDanger! +
          ((getKeyForDangerInspections(waitFix.waitFixDegree!) ==
                  "normalDanger")
              ? 1
              : 0),
      highDanger: state!.highDanger! +
          ((getKeyForDangerInspections(waitFix.waitFixDegree!) == "highDanger")
              ? 1
              : 0),
      expertName: state!.expertName,
      currentHasMustFixCount: state!.currentHasMustFixCount! + 1,
        customerPresentationName : state!.customerPresentationName,
        customerAddress : state!.customerAddress,
        customerSector : state!.customerSector,
        dangerLevelOfCustomer : state!.dangerLevelOfCustomer,
      workerCount: state!.workerCount
    );
    changeCurrentInspection(inspection);
  }

  String getKeyForDangerInspections(String value) {
    switch (value) {
      case "Yapılması Önerilir":
        return "lowDanger";
      case "Önemli":
        return "normalDanger";
      case "Çok Önemli":
        return "highDanger";
      default:
        return "normalDanger";
    }
  }

  void removeWaitFix(WaitFix waitFix) {
    state!.waitFixList!.remove(waitFix as dynamic);
    for (var element in state!.waitFixList!) {
      debugPrint(element.toString());
      if (element is WaitFix) {
        debugPrint(element.toJson().toString());
        debugPrint(waitFix.toJson().toString());
        if (element.toJson().toString() == waitFix.toJson().toString()) {
          state!.waitFixList!.remove(element);
          if(getKeyForDangerInspections(waitFix.waitFixDegree!) == "lowDanger"){
            state!.lowDanger =  state!.lowDanger! - 1;
          }else if((getKeyForDangerInspections(waitFix.waitFixDegree!) ==
              "normalDanger")){
            state!.normalDanger =  state!.normalDanger! - 1;
          }else{
            state!.highDanger =  state!.highDanger! - 1;
          }
          NavigationService.instance.navigatePopUp();
        } else {
          debugPrint("bingo2");
        }
      }
    }

    var newInspection = Inspection(
      inspectionID: state!.inspectionID,
      customerID: state!.customerID,
      doctorID: state!.doctorID,
      customerName: state!.customerName,
      customerPhotoURL: state!.customerPhotoURL,
      expertID: state!.expertID,
      inspectionIsStarted: state!.inspectionIsStarted,
      inspectionIsDone: state!.inspectionIsDone,
      inspectionExplain: state!.inspectionExplain,
      inspectionDate: state!.inspectionDate,
      createdDate: state!.createdDate ?? DateTime.now().toString().substring(0,16),
      updatedDate: DateTime.now().toString().substring(0,16),
      doctorName: state!.doctorName,
      waitFixList: state!.waitFixList!,
      lowDanger: (state!.lowDanger! +
          ((getKeyForDangerInspections(waitFix.waitFixDegree!) == "lowDanger")
              ? -1
              : 0)),
      normalDanger: (state!.normalDanger! +
          ((getKeyForDangerInspections(waitFix.waitFixDegree!) ==
                  "normalDanger")
              ? -1
              : 0)),
      highDanger: state!.highDanger! +
          ((getKeyForDangerInspections(waitFix.waitFixDegree!) == "highDanger")
              ? -1
              : 0),
      expertName: state!.expertName,
      currentHasMustFixCount: state!.currentHasMustFixCount! + (-1),
      customerPresentationName : state!.customerPresentationName,
      customerAddress : state!.customerAddress,
      customerSector : state!.customerSector,
      dangerLevelOfCustomer : state!.dangerLevelOfCustomer,
      workerCount: state!.workerCount
    );

    changeCurrentInspection(newInspection);
  }
}
