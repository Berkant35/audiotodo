import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/ui/admin/pages/visit_tab_bar_views/custom_list.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../line/viewmodel/app_view_models/appBar_managers/custom_flexible_model.dart';
import '../../../../line/viewmodel/global_providers.dart';
import '../../../../models/inspection.dart';
import '../../../../utilities/components/custom_animated_search_bar.dart';
import '../../../../utilities/components/custom_card.dart';
import '../../../../utilities/constants/extension/context_extensions.dart';
import '../../../../utilities/init/navigation/navigation_constants.dart';
import '../../../../utilities/init/navigation/navigation_service.dart';

class WaitVisits extends ConsumerStatefulWidget {
  const WaitVisits({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _WaitVisitsState();
}

class _WaitVisitsState extends ConsumerState<WaitVisits> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Inspection>?>(
        future:
            ref.read(currentAdminWorksState.notifier).getInspectionList(false),
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
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        "Yapılacak bir ziyaret bulunmamaktadır",
                        style: ThemeValueExtension.subtitle,
                      ),
                    )
              : const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
        });
  }
}


