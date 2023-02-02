import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:search_choices/search_choices.dart';

import '../../models/worker.dart';
import '../init/theme/custom_colors.dart';

class AddWorkerDialogs extends ConsumerStatefulWidget {
  final Function(List<Worker> values) selectedWorkerList;

  const AddWorkerDialogs({Key? key, required this.selectedWorkerList})
      : super(key: key);

  @override
  ConsumerState createState() => _AddWorkerDialogsState();
}

class _AddWorkerDialogsState extends ConsumerState<AddWorkerDialogs> {
  List<Worker> selectedWorkerList = [];
  List<Worker> allWorkerList = [];
  List<int> selectedWorkerIndex = [];
  List<DropdownMenuItem> allWorker = [];

  @override
  void initState() {
    super.initState();
    ref
        .read(currentAdminWorksState.notifier)
        .getWorkersOfCompany(
            ref.read(currentBaseModelState).customer!.rootUserID!)
        .then((workerList) {
      if (workerList != null && workerList.isNotEmpty) {
        for (int i = 0; i < workerList.length; i++) {
          var perWorker = workerList[i];

          allWorkerList.add(perWorker);
          allWorker.add(DropdownMenuItem(
              value: perWorker.workerName,
              child: Text(
                perWorker.workerName!,
                style: ThemeValueExtension.subtitle2,
              )));
        }
      }
      ref.read(currentLoadingState.notifier).changeState(LoadingStates.loaded);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(currentLoadingState) != LoadingStates.loading
        ? SearchChoices.multiple(
            items: allWorker,
            selectedItems: selectedWorkerIndex,
            hint: "Çalışanlarınızı Seçin",
            searchHint: "Çalışanı Bul",
            listValidator: (selectedItemsForValidator) {
              if (selectedItemsForValidator.isEmpty) {
                return "En az bir tane çalışan seçmelisiniz";
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                selectedWorkerIndex = value;
              });
            },
            doneButton: (selectedItemsDone, doneContext) {

              return Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(

                    onPressed: selectedItemsDone.length == 0
                        ? null
                        : () {
                            selectedWorkerList.clear();
                            for (var value in (selectedItemsDone as List<int>)) {
                              selectedWorkerList.add(allWorkerList[value]);
                            }

                            widget.selectedWorkerList(selectedWorkerList);

                            Navigator.pop(doneContext);

                            setState(() {});
                          },
                    style:  ButtonStyle(
                      backgroundColor: CustomColors.secondaryColorM,
                      foregroundColor: const MaterialStatePropertyAll<Color>(Colors.white)
                    ),
                    child: Text("Seç",style: ThemeValueExtension.subtitle,),
                ),
              );
            },
            closeButton: (selectedItemsClose) {
              selectedWorkerList.clear();

              for (var value in (selectedItemsClose as List<int>)) {
                selectedWorkerList.add(allWorkerList[value]);
              }

              widget.selectedWorkerList(selectedWorkerList);

              debugPrint("Selected Items Close $selectedItemsClose");
              return (selectedItemsClose.length > 1 ? "Ekle" : null);
            },
            isExpanded: true,
          )
        : const Center(
            child: CircularProgressIndicator.adaptive(),
          );
  }
}
