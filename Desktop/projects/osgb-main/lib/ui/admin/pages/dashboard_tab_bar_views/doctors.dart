import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/models/doctor.dart';
import 'package:osgb/ui/details/expert/common_doctor_detail.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../line/viewmodel/app_view_models/appBar_managers/custom_flexible_model.dart';
import '../../../../line/viewmodel/global_providers.dart';
import '../../../../utilities/components/custom_card.dart';
import '../../../../utilities/constants/extension/context_extensions.dart';

class Doctors extends ConsumerStatefulWidget {
  const Doctors({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _DoctorsState();
}

class _DoctorsState extends ConsumerState<Doctors> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: FutureBuilder<List<Doctor>>(
          future: ref
              .read(currentAdminWorksState.notifier)
              .getDoctorListWithType(ref),
          builder: (context, snapshot) {
            var doctorList = snapshot.data;
            return snapshot.connectionState == ConnectionState.done
                ? doctorList!.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemExtent: 15.h,
                        padding: EdgeInsets.only(bottom: 5.h),
                        itemCount: doctorList.length,
                        itemBuilder: (context, index) {
                          var perDoctor = doctorList[index];
                          return Padding(
                            padding: EdgeInsets.all(1.h),
                            child: CustomCard(
                                networkImage: perDoctor.photoURL,
                                header1: "Hekim Adı",
                                content1: perDoctor.doctorName ?? "Adı Yok",
                                header2: "E-Mail",
                                content2:
                                    perDoctor.doctorMail ?? "Belirtilmemiş",
                                header3: "Telefon Numarası",
                                content3: perDoctor.doctorPhoneNumber ??
                                    "Belirtilmemiş",
                                navigationContentText: "İncele",
                                onClick: () {
                                  ref
                                      .read(currentCustomFlexibleAppBarState
                                          .notifier)
                                      .changeContentFlexibleManager(
                                          CustomFlexibleModel(
                                              header1: "Hekim Adı",
                                              header2: "Telefon",
                                              header3: "E-Mail",
                                              content1:
                                              perDoctor.doctorName ?? "-",
                                              content2: perDoctor.doctorPhoneNumber,
                                              content3: perDoctor.doctorMail,
                                              backAppBarTitle: "Hekim Detay",
                                              photoUrl: perDoctor.photoURL));
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CommonDoctorDetail(
                                          doctor: perDoctor)));
                                }),
                          );
                        })
                    : Center(
                        child: Text(
                        "Henüz bir hekim yok",
                        style: ThemeValueExtension.subtitle,
                      ))
                : const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
          }),
    );
  }
}
