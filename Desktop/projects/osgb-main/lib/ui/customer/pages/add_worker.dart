import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanoid/async.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/demand.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../models/city_list_of_turkey.dart';
import '../../../models/customer.dart';
import '../../../models/notification_model.dart';
import '../../../models/worker.dart';
import '../../../utilities/components/row_form_field.dart';
import '../../../utilities/components/seperate_padding.dart';
import '../../../utilities/components/single_photo_container.dart';
import '../../../utilities/constants/app/application_constants.dart';
import '../../../utilities/constants/extension/context_extensions.dart';
import '../../../utilities/init/theme/custom_colors.dart';

class AddWorker extends ConsumerStatefulWidget {
  const AddWorker({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddWorkerState();
}

class _AddWorkerState extends ConsumerState<AddWorker> {
  late TextEditingController workerNameAndSurnameController;

  late TextEditingController workerPhoneNumberController;
  late TextEditingController workerAddressController;
  late TextEditingController workerMissionController;
  late TextEditingController dateController;

  File? workerPhotoFile;
  String? city;
  String? district;
  String? address;
  CityListOfTurkey listCities =
      CityListOfTurkey.fromJson(CountriesInfo.citiesAndDistrict);

  final _addWorkerFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    workerNameAndSurnameController = TextEditingController();
    workerPhoneNumberController = TextEditingController();
    workerAddressController = TextEditingController();
    workerMissionController = TextEditingController();

    dateController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    workerNameAndSurnameController.dispose();
    workerPhoneNumberController.dispose();
    workerAddressController.dispose();
    workerMissionController.dispose();

    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Padding(
            padding: EdgeInsets.only(left: 5.w, top: 1.h, right: 5.w),
            child: SingleChildScrollView(
              child: Form(
                key: _addWorkerFormKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      Padding(
                        padding: EdgeInsets.all(context.lowValue),
                        child: Text(
                          'Yeni Çalışan Bildir',
                          style: ThemeValueExtension.headline6
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      RowFormField(
                        headerName: 'Çalışan Adı ve Soyadı',
                        hintText: ApplicationConstants.hintName,
                        editingController: workerNameAndSurnameController,
                        custValidateFunction: (value) =>
                            value != "" ? null : "Bu alan boş bırakılamaz",
                      ),
                      Padding(
                        padding: seperatePadding(),
                        child: Text(
                          'Çalışan Fotoğraf',
                          style: ThemeValueExtension.subtitle,
                        ),
                      ),
                      SinglePhotoArea(
                        onSaved: (file) {
                          workerPhotoFile = file;
                        },
                        showInArea: true,
                      ),
                      RowFormField(
                        headerName: 'Çalışan Telefon Numarası',
                        editingController: workerPhoneNumberController,
                        hintText: ApplicationConstants.hintPhoneNumber,
                        custValidateFunction: (value) {
                          String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                          RegExp regExp = RegExp(patttern);

                          if (value!.isEmpty) {
                            return "Lütfen telefon numarası giriniz";
                          } else if (!regExp.hasMatch(value)) {
                            return "Lütfen geçerli bir telefon numarası giriniz";
                          } else {
                            return null;
                          }
                        },
                      ),
                      RowFormField(
                        headerName: 'Görevi',
                        editingController: workerMissionController,
                        hintText: ApplicationConstants.hintMission,
                        custValidateFunction: (value) =>
                            value != "" ? null : "Bu alan boş bırakılamaz",
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Çalışma Başlangıç Tarihi",
                              style: ThemeValueExtension.subtitle,
                            ),
                            DateTimePicker(
                              type: DateTimePickerType.date,
                              dateMask: 'd MMM, yyyy',
                              controller: dateController,
                              //initialValue: _initialValue,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              icon: const Icon(
                                Icons.event,
                                color: CustomColors.secondaryColor,
                              ),
                              style: ThemeValueExtension.subtitle,
                              //use24HourFormat: false,
                              //locale: Locale('pt', 'BR'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      ref.watch(currentButtonLoadingState) !=
                              LoadingStates.loading
                          ? CustomElevatedButton(
                              onPressed: () async {
                                _addWorkerFormKey.currentState!.save();

                                if (_addWorkerFormKey.currentState!
                                    .validate()) {
                                  var uniqueID = await nanoid();

                                  var worker = Worker(
                                      typeOfUser: 'worker',

                                      workerPassword: "123456",
                                      workerName:
                                          workerNameAndSurnameController.text,
                                      workerCompanyID: ref
                                          .read(currentBaseModelState)
                                          .customer!
                                          .rootUserID,
                                      workerJob: workerMissionController.text,
                                      workerPhoneNumber:
                                          workerPhoneNumberController.text,
                                      startAtCompanyDate: dateController.text);
                                  ref
                                      .read(currentCustomerWorksState.notifier)
                                      .createDemandWorker(
                                        ref,
                                        DemandWorker(
                                            demandID: uniqueID,
                                            demandWorker: worker,
                                            demandByCustomer: ref
                                                .read(currentBaseModelState)
                                                .customer),
                                        workerPhotoFile,
                                      )
                                      .then((value) {
                                    sendNotificationToAdmin(worker);
                                  });
                                }
                              },
                              inButtonText: "Yeni Çaluşan Talebi Oluştur",
                              primaryColor: CustomColors.orangeColorM,
                            )
                          : const Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                      SizedBox(
                        height: 25.h,
                      ),
                    ]),
              ),
            )));
  }

  Future<Null> sendNotificationToAdmin(Worker worker) {
    return ref
                                      .read(currentBaseModelState.notifier)
                                      .getAdmin()
                                      .then((admin) {
                                    ref
                                        .read(currentPushNotificationState
                                            .notifier)
                                        .sendPush(NotificationModel(
                                            to: admin!.pushToken!,
                                            priority: "high",
                                            notification: CustomNotification(
                                                title:
                                                    "Yeni Çalışan Talebi Oluşturuldu",
                                                body:
                                                    "${worker.workerName} çalışanı için ${ref.read(currentBaseModelState).customer!.customerName} işyerinden talep oluşturuldu")));
                                  });
  }

  Icon dropIcon() => const Icon(Icons.arrow_drop_down);

  Text hintText(String text) {
    return Text(
      text,
      style: ThemeValueExtension.subtitle2,
    );
  }

  Container underLine() {
    return Container(
      width: context.width,
      height: 0,
      color: CustomColors.secondaryColor,
    );
  }

  void districtOnChanged(String? value) {
    district = null;
    setState(() {});
    district = value;
    setState(() {});
  }

  List<DropdownMenuItem<String>> list(List<Districts> listOfDistrict) {
    return listOfDistrict.map<DropdownMenuItem<String>>((Districts value) {
      return DropdownMenuItem<String>(
        value: value.text,
        child: Text(
          value.text!,
          style: ThemeValueExtension.subtitle3.copyWith(color: Colors.black),
        ),
      );
    }).toList();
  }

  Padding dropLists(BuildContext context) {
    return Padding(
      padding: seperatePadding(),
      child: Row(
        children: [
          Expanded(child: getCityList(context)),
          Expanded(
              child:
                  city != null ? getCityOfDistrictList(city) : const SizedBox())
        ],
      ),
    );
  }

  Column getCityList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "İl",
          style: ThemeValueExtension.subtitle2,
        ),
        listCities.cityList == null
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : DropdownButton<String>(
                value: city,
                hint: hintText("İl"),
                isDense: false,
                icon: dropIcon(),
                elevation: 0,
                style: ThemeValueExtension.subtitle2,
                underline: underLine(),
                onChanged: onChangedCityDrop,
                items: cityListDropDownMenu(),
              ),
      ],
    );
  }

  List<DropdownMenuItem<String>> cityListDropDownMenu() {
    return listCities.cityList!.map<DropdownMenuItem<String>>((CityList value) {
      return DropdownMenuItem<String>(
        value: value.text,
        child: Text(
          value.text!,
          style: ThemeValueExtension.subtitle3.copyWith(color: Colors.black),
        ),
      );
    }).toList();
  }

  void onChangedCityDrop(String? value) {
    city = null;
    district = null;
    setState(() {});

    city = value;
    setState(() {});
  }

  Widget getCityOfDistrictList(String? city) {
    var listOfDistrict = <Districts>[];

    for (var element in listCities.cityList!) {
      if (element.text == city) {
        listOfDistrict = element.districts!;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hintText("İlçe"),
        DropdownButton<String>(
          value: district,
          hint: hintText("İlçe"),
          isDense: false,
          icon: dropIcon(),
          elevation: 0,
          style: ThemeValueExtension.subtitle2,
          underline: underLine(),
          onChanged: districtOnChanged,
          items: list(listOfDistrict),
        ),
      ],
    );
  }
}
