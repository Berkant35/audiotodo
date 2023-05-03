import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/ui/admin/pages/visit_tab_bar_views/custom_list.dart';
import 'package:osgb/utilities/components/custom_card.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../line/viewmodel/app_view_models/appBar_managers/custom_flexible_model.dart';
import '../../../../models/customer.dart';
import '../../../../models/inspection.dart';
import '../../../../utilities/init/navigation/navigation_constants.dart';

class DoneVisits extends ConsumerStatefulWidget {
  const DoneVisits({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _DoneVisitsState();
}

class _DoneVisitsState extends ConsumerState<DoneVisits> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Inspection>?>(
        future:
            ref.read(currentAdminWorksState.notifier).getInspectionList(true),
        builder: (context, snapshot) {
          var list = snapshot.data;
          return snapshot.connectionState == ConnectionState.done
              ? list!.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomList(list: list),
                          SizedBox(
                            height: 20.h,
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        "Yapılan bir ziyaret bulunmamaktadır",
                        style: ThemeValueExtension.subtitle,
                      ),
                    )
              : const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
        });
  }
}
