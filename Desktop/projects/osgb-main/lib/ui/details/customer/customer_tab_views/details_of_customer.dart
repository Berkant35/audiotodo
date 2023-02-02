import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:osgb/models/customer.dart';
import 'package:osgb/models/doctor.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../line/viewmodel/global_providers.dart';
import '../../../../models/city_list_of_turkey.dart';
import '../../../../models/expert.dart';
import '../../../../utilities/components/choose_period.dart';
import '../../../../utilities/components/danger_check_list.dart';
import '../../../../utilities/components/download_image.dart';
import '../../../../utilities/components/list_of_expansion_list.dart';
import '../../../../utilities/components/row_form_field.dart';
import '../../../../utilities/components/single_photo_container.dart';
import '../../../../utilities/constants/app/application_constants.dart';
import '../../../../utilities/constants/app/enums.dart';
import '../../../../utilities/init/theme/custom_colors.dart';

class DetailsOfCustomer extends ConsumerStatefulWidget {
  final Customer customer;
  final Function(String value) onSaved;
  const DetailsOfCustomer({
    Key? key,
    required this.onSaved,
    required this.customer,
  }) : super(key: key);

  @override
  ConsumerState createState() => _DetailsOfCustomerState();
}

class _DetailsOfCustomerState extends ConsumerState<DetailsOfCustomer> {
  late TextEditingController nameAndSurnameCustomerController;
  late TextEditingController customerEmail;
  late TextEditingController customerPassword;
  late TextEditingController sectorController;
  late TextEditingController addressController;
  late TextEditingController phoneNumberController;
  late TextEditingController companyRecordNumberController;
  late TextEditingController presentationNameAndSurnameController;
  late TextEditingController presentationPhoneNumberController;
  final _updateCustomerKey = GlobalKey<FormState>();

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

  Doctor? doctor;

  CityListOfTurkey listCities =
      CityListOfTurkey.fromJson(CountriesInfo.citiesAndDistrict);

  @override
  void initState() {
    var expert = Expert.fromJson(widget.customer.definedExpert);

    if (widget.customer.definedDoctor != null) {
      doctor = Doctor.fromJson(widget.customer.definedDoctor);
    }
    super.initState();
    district = widget.customer.customerDistrict;
    city = widget.customer.customerCity;
    address = widget.customer.customerAddress;
    dangerLevel = widget.customer.dangerLevel;
    choosedExpert = expert.expertName;
    choosedExpertID = expert.rootUserID!;
    choosedDoctor = doctor?.doctorName;
    choosedDoctorID = doctor?.rootUserID;
    onSavedForDaily = widget.customer.dailyPeriod;
    nameAndSurnameCustomerController =
        TextEditingController(text: widget.customer.customerName);
    customerEmail = TextEditingController(text: widget.customer.email);
    customerPassword = TextEditingController(text: widget.customer.password);
    sectorController =
        TextEditingController(text: widget.customer.customerSector);
    addressController =
        TextEditingController(text: widget.customer.customerAddress);
    phoneNumberController =
        TextEditingController(text: widget.customer.customerPhoneNumber);
    presentationNameAndSurnameController =
        TextEditingController(text: widget.customer.representativePerson);
    presentationPhoneNumberController =
        TextEditingController(text: widget.customer.customerPhoneNumber);

    companyRecordNumberController =
        TextEditingController(text: widget.customer.companyDetectNumber);
  }

  @override
  void dispose() {
    super.dispose();
    nameAndSurnameCustomerController.dispose();
    customerEmail.dispose();
    customerPassword.dispose();
    sectorController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    presentationNameAndSurnameController.dispose();
    presentationPhoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(choosedDoctor);
    return Form(
      key: _updateCustomerKey,
      child: Padding(
        padding: seperatePadding(),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            DownloadImage(
                imageLink: widget.customer.qrCodeURL!,
                fileName: widget.customer.customerName!),
            Text(
              "Güncelle",
              style: ThemeValueExtension.subtitle
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
            colAddPhoto(),
            SizedBox(
              height: 2.h,
            ),
            dropLists(context),
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
              currentChoosedDangerLevel: dangerLevel,
              onSaved: (String dangerValue) {
                dangerLevel = dangerValue;
              },
            ),
            RowFormField(
              headerName: "İşyeri Sicil No",
              hintText: "xxxxxxxxxxxxxxxxxxxxxxxxxxx",
              editingController: companyRecordNumberController,
              maxLength: ApplicationConstants.companyRecordNumberTextLength,
              visibleStatus: true,
              custValidateFunction: (value) =>
                  value != "" ? null : "Bu alan boş bırakılamaz",
            ),
            selectExpert(
                Expert.fromJson(widget.customer.definedExpert).expertName!),
            selectDoctor(choosedDoctor),
            ChoosePeriod(
              choosedPeriod: onSavedForDaily,
              onSavedForDaily: (String dailyPeriod) {
                onSavedForDaily = dailyPeriod;
                setState(() {});
              },
            ),
            RowFormField(
              headerName: "Adres",
              editingController: addressController,
              hintText: "Kemal paşa sok...",
              visibleStatus: null,
              custValidateFunction: (value) =>
                  value != "" ? null : "Bu alan boş bırakılamaz",
              maxLines: 5,
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
            buttons(),
            SizedBox(
              height: 40.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget buttons() {
    return ref.watch(currentButtonLoadingState) != LoadingStates.loading
        ? Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: CustomElevatedButton(
                onPressed: () async {
                  if (choosedExpertID != null &&
                      _updateCustomerKey.currentState!.validate()) {
                    var expert = await ref
                        .read(currentAdminWorksState.notifier)
                        .getRoleUser(choosedExpertID!);

                    dynamic doctor;

                    if (choosedDoctorID != null) {
                      doctor = await ref
                          .read(currentAdminWorksState.notifier)
                          .getRoleUser(choosedDoctorID!);
                    }

                    var currentCustomer = Customer(
                        customerCity: city,
                        customerAddress: addressController.text,
                        customerDistrict: district,
                        rootUserID: widget.customer.rootUserID,
                        customerID: null,
                        photoURL: widget.customer.photoURL,
                        dangerLevel: dangerLevel,
                        qrCodeURL: widget.customer.qrCodeURL,
                        customerName: nameAndSurnameCustomerController.text,
                        customerPhoneNumber: phoneNumberController.text,
                        companyDetectNumber: companyRecordNumberController.text,
                        customerSector: sectorController.text,
                        representativePerson:
                            presentationNameAndSurnameController.text,
                        representativePersonPhone:
                            presentationPhoneNumberController.text,
                        accidentCaseList: [],
                        email: customerEmail.text,
                        definedDoctor:
                            doctor != null ? (doctor as Doctor).toJson() : null,
                        definedExpert: (expert as Expert).toJson(),
                        dailyPeriod: onSavedForDaily,
                        password: customerPassword.text,
                        typeOfUser: 'customer');

                    ref
                        .read(currentAdminWorksState.notifier)
                        .updateCustomer(currentCustomer, ref, logoLocalPath).then((value){
                          widget.onSaved("On Saved");
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "Lütfen belirtilen alanları doldurunuz");
                  }
                },
                inButtonText: "Durumu Güncelle",
                primaryColor: CustomColors.orangeColorM),
          )
        : const Center(
            child: CircularProgressIndicator.adaptive(),
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
        Center(
          child: SinglePhotoArea(
            photoUrl: ref.watch(currentCustomFlexibleAppBarState).photoUrl,
            onSaved: (value) {
              logoLocalPath = value;
              setState(() {});
            },
            showInArea: true,
          ),
        ),
      ],
    );
  }

  Column selectExpert(String defaultValueExpert) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: seperatePadding(),
          child: Text("Uzman", style: ThemeValueExtension.subtitle),
        ),
        GetExpansionChooseList(
          defaultValue: choosedExpert,
          onSaved: (String? value, String? expertID) {
            choosedExpert = value;
            choosedExpertID = expertID;
          },
          getFutureList:
              ref.read(currentAdminWorksState.notifier).getExpertList(ref),
          title: "Uzman Seç",
          keyOfMap: "expertName",
        ),
      ],
    );
  }

  Widget selectDoctor(String? defaultValueDoctor) {
    debugPrint("Select Doctor");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: seperatePadding(),
          child: Text("Hekim", style: ThemeValueExtension.subtitle),
        ),
        GetExpansionChooseList(
          showRemove: true,
          defaultValue: choosedDoctor,
          onSaved: (String? value, String? doctorID) {
            choosedDoctor = value;
            choosedDoctorID = doctorID;
          },
          getFutureList:
              ref.read(currentAdminWorksState.notifier).getDoctorList(ref),
          title: "Hekim Seç",
          keyOfMap: "doctorName",
        ),
      ],
    );
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

  void districtOnChanged(String? value) {
    district = null;
    setState(() {});
    district = value;
    setState(() {});
  }

  Container underLine() {
    return Container(
      width: context.width,
      height: 0,
      color: CustomColors.secondaryColor,
    );
  }

  Icon dropIcon() => const Icon(Icons.arrow_drop_down);

  Text hintText(String text) {
    return Text(
      text,
      style: ThemeValueExtension.subtitle2,
    );
  }
}
