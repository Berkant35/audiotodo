import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/doctor.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../models/city_list_of_turkey.dart';
import '../../../../models/customer.dart';
import '../../../../models/expert.dart';
import '../../../../utilities/components/choose_period.dart';
import '../../../../utilities/components/danger_check_list.dart';
import '../../../../utilities/components/list_of_expansion_list.dart';
import '../../../../utilities/components/row_form_field.dart';
import '../../../../utilities/components/seperate_padding.dart';
import '../../../../utilities/components/single_photo_container.dart';
import '../../../../utilities/constants/app/application_constants.dart';
import '../../../../utilities/init/theme/custom_colors.dart';

class AddCustomer extends ConsumerStatefulWidget {
  const AddCustomer({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddCustomerState();
}

class _AddCustomerState extends ConsumerState<AddCustomer> {
  late TextEditingController nameAndSurnameCustomerController;
  late TextEditingController customerEmail;
  late TextEditingController customerPassword;
  late TextEditingController sectorController;
  late TextEditingController addressController;
  late TextEditingController phoneNumberController;
  late TextEditingController companyRecordNumberController;
  late TextEditingController presentationNameAndSurnameController;
  late TextEditingController presentationPhoneNumberController;
  final _addCustomerFormKey = GlobalKey<FormState>();

  File? logoLocalPath;
  String? city;
  String? district;
  String? address;
  String? dangerLevel;
  String? choosedExpert;
  String? choosedExpertID;
  String? choosedDoctor;
  String? choosedDoctorID;
  String? onSavedForDaily;

  CityListOfTurkey listCities =
      CityListOfTurkey.fromJson(CountriesInfo.citiesAndDistrict);

  @override
  void initState() {
    super.initState();
    nameAndSurnameCustomerController = TextEditingController();
    customerEmail = TextEditingController();
    customerPassword = TextEditingController();
    sectorController = TextEditingController();
    addressController = TextEditingController();
    phoneNumberController = TextEditingController();
    presentationNameAndSurnameController = TextEditingController();
    presentationPhoneNumberController = TextEditingController();

    companyRecordNumberController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    nameAndSurnameCustomerController.dispose();
    customerPassword.dispose();
    customerEmail.dispose();
    sectorController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    presentationNameAndSurnameController.dispose();
    presentationPhoneNumberController.dispose();
    companyRecordNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
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
              key: _addCustomerFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "İş Yeri Ekle",
                    style: ThemeValueExtension.headline6
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RowFormField(
                    headerName: "İş Yeri Adı",
                    editingController: nameAndSurnameCustomerController,
                    visibleStatus: null,
                    hintText: ApplicationConstants.hintName,
                    custValidateFunction: (value) =>
                        value != "" ? null : "Bu alan boş bırakılamaz",
                  ),
                  RowFormField(
                    headerName: "İş Yeri E-Mail",
                    editingController: customerEmail,
                    hintText: ApplicationConstants.hintEmail,
                    visibleStatus: null,
                    custValidateFunction: (value) =>
                        value != "" ? null : "Bu alan boş bırakılamaz",
                  ),
                  RowFormField(
                    headerName: "İş Yeri Şifre",
                    editingController: customerPassword,
                    hintText: ApplicationConstants.hintPassword,
                    visibleStatus: true,
                    custValidateFunction: (value) =>
                        value != "" && value != null
                            ? value.length >= 6
                                ? null
                                : "Şifre 6 karakterden fazla olmalıdır"
                            : "Bu alan boş bırakılamaz",
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  colAddPhoto(),
                  SizedBox(
                    height: 2.h,
                  ),
                  dropLists(context),
                  SizedBox(
                    height: 2.h,
                  ),
                  RowFormField(
                    headerName: "İş Yeri Adresi",
                    editingController: addressController,
                    hintText: "Kemap paşa sok...",
                    visibleStatus: null,
                    custValidateFunction: (value) =>
                        value != "" ? null : "Bu alan boş bırakılamaz",
                    maxLines: 5,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RowFormField(
                    headerName: "Sektör",
                    hintText: "İnşaat",
                    editingController: sectorController,
                    visibleStatus: null,
                    custValidateFunction: (value) =>
                        value != "" ? null : "Bu alan boş bırakılamaz",
                  ),
                  //Tehlikeli az tehlikeli gelecek
                  DangerCheckList(
                    onSaved: (String dangerValue) {
                      dangerLevel = dangerValue;
                    },
                  ),
                  RowFormField(
                    headerName: "İşyeri Sicil No",
                    hintText: "xxxxxxxxxxxxxxxxxxxxxxxxxxx",
                    editingController: companyRecordNumberController,
                    maxLength:
                        ApplicationConstants.companyRecordNumberTextLength,
                    custValidateFunction: (value) =>
                        value != "" ? null : "Bu alan boş bırakılamaz",
                  ),
                  selectExpert(),
                  selectDoctor(),
                  ChoosePeriod(
                    onSavedForDaily: (String dailyPeriod) {
                      onSavedForDaily = dailyPeriod;
                    },
                  ),

                  RowFormField(
                    headerName: "Telefon",
                    editingController: phoneNumberController,
                    visibleStatus: null,
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
                    hintText: ApplicationConstants.hintPhoneNumber,
                    inputType: TextInputType.phone,
                  ),
                  RowFormField(
                    headerName: "Yetkili Kişi Adı ve Soyadı",
                    editingController: presentationNameAndSurnameController,
                    visibleStatus: null,
                    custValidateFunction: (value) =>
                        value != "" ? null : "Bu alan boş bırakılamaz",
                    hintText: ApplicationConstants.hintName,
                  ),
                  RowFormField(
                    headerName: "Yetkili Kişinin Telefon Numarası",
                    editingController: presentationPhoneNumberController,
                    hintText: ApplicationConstants.hintPhoneNumber,
                    visibleStatus: null,
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
                    inputType: TextInputType.phone,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  ref.watch(currentButtonLoadingState) != LoadingStates.loading
                      ? CustomElevatedButton(
                          onPressed: () async {
                            _addCustomerFormKey.currentState!.save();
                            Doctor? doctor;
                            if (choosedExpertID != null &&
                                _addCustomerFormKey.currentState!.validate()) {
                              var expert = await ref
                                  .read(currentAdminWorksState.notifier)
                                  .getRoleUser(choosedExpertID!);
                              if (choosedDoctorID != null) {
                                doctor = await ref
                                    .read(currentAdminWorksState.notifier)
                                    .getRoleUser(choosedDoctorID!);
                              }

                              var customer = Customer(
                                  customerCity: city,
                                  customerAddress: addressController.text,
                                  customerDistrict: district,
                                  customerID: null,
                                  dangerLevel: dangerLevel,
                                  customerName:
                                      nameAndSurnameCustomerController.text,
                                  customerPhoneNumber:
                                      phoneNumberController.text,
                                  companyDetectNumber:
                                      companyRecordNumberController.text,
                                  customerSector: sectorController.text,
                                  representativePerson:
                                      presentationNameAndSurnameController.text,
                                  representativePersonPhone:
                                      presentationPhoneNumberController.text,
                                  accidentCaseList: [],
                                  email: customerEmail.text,
                                  definedDoctor: doctor?.toJson(),
                                  definedExpert: (expert as Expert).toJson(),
                                  dailyPeriod: onSavedForDaily,
                                  password: customerPassword.text,
                                  typeOfUser: 'customer');

                              ref
                                  .read(currentAdminWorksState.notifier)
                                  .createCustomer(customer, ref, logoLocalPath,
                                      Roles.customer);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Lütfen belirtilen alanları doldurunuz");
                            }
                          },
                          inButtonText: "İş Yeri Ekle",
                          primaryColor: CustomColors.orangeColorM,
                        )
                      : const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                  SizedBox(
                    height: 40.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column selectExpert() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: seperatePadding(),
          child: Text("Uzman", style: ThemeValueExtension.subtitle),
        ),
        GetExpansionChooseList(
          onSaved: (String? value, String? expertID) {
            choosedExpert = value;
            choosedExpertID = expertID;
          },
          defaultValue: choosedExpert,
          getFutureList:
              ref.read(currentAdminWorksState.notifier).getExpertList(ref),
          title: "Uzman Seç",
          keyOfMap: "expertName",
        ),
      ],
    );
  }

  Column selectDoctor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: seperatePadding(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Hekim", style: ThemeValueExtension.subtitle),
              IconButton(
                  onPressed: () {
                    choosedDoctor = null;
                    choosedDoctorID = null;
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.delete_forever_sharp,
                    size: 3.25.h,
                  ))
            ],
          ),
        ),
        GetExpansionChooseList(
          onSaved: (String? value, String? doctorID) {
            choosedDoctor = value;
            choosedDoctorID = doctorID;
          },
          defaultValue: choosedDoctor,
          getFutureList:
              ref.read(currentAdminWorksState.notifier).getDoctorList(ref),
          title: "Hekim Seç",
          keyOfMap: "doctorName",
        ),
      ],
    );
  }

  Column colAddPhoto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: seperatePadding(),
          child: Text(
            "İş Yeri Logosu(opsiyonel)",
            style: ThemeValueExtension.subtitle,
          ),
        ),
        SinglePhotoArea(
          onSaved: (value) {
            logoLocalPath = value;
          },
          showInArea: true,
        ),
      ],
    );
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
          style: ThemeValueExtension.subtitle,
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
