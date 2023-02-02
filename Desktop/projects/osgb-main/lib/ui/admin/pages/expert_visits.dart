import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/ui/admin/pages/visit_tab_bar_views/done_visits.dart';
import 'package:osgb/ui/admin/pages/visit_tab_bar_views/wait_visits.dart';

import '../../../custom_functions.dart';
import '../../../utilities/constants/extension/context_extensions.dart';
import '../../../utilities/init/theme/custom_colors.dart';


class ExpertVisits extends ConsumerStatefulWidget {
  const ExpertVisits({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ExpertVisitsState();
}

class _ExpertVisitsState extends ConsumerState<ExpertVisits>   with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: ref.read(currentVisitTabIndexState));
    tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      resizeToAvoidBottomInset: false,
      body: TabBarView(
          controller: tabController,
          children: const [
            DoneVisits(),
            WaitVisits(),
          ]),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      toolbarHeight: context.height * 0.07,
      elevation: 0,
      centerTitle: false,
      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: SizedBox(
            child: TabBar(
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.white,
              indicatorWeight: CustomFunctions.isPhone() ? 1 : 5,
              tabs: [
                Tab(
                  child: Text(
                    'Yapılan Ziyaretler',
                    style: ThemeValueExtension.subtitle3.copyWith(
                        color: ref.watch(currentVisitTabIndexState) == 0
                            ? CustomColors.secondaryColor
                            : Colors.black,
                        fontWeight: ref.watch(currentVisitTabIndexState) == 0
                            ? FontWeight.bold
                            : FontWeight.w500,
                        fontSize: ref.watch(currentVisitTabIndexState) == 0
                            ? ThemeValueExtension.subtitle2.fontSize
                            : ThemeValueExtension.subtitle3.fontSize
                    ),
                  ),
                ),

                Tab(
                  child: Text('Yapılmamış Ziyaretler',
                      style: ThemeValueExtension.subtitle3.copyWith(
                          color: ref.watch(currentVisitTabIndexState) == 1
                              ? CustomColors.secondaryColor
                              : Colors.black,
                          fontWeight: ref.watch(currentVisitTabIndexState) == 1
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: ref.watch(currentVisitTabIndexState) == 1
                              ? ThemeValueExtension.subtitle2.fontSize
                              : ThemeValueExtension.subtitle3.fontSize
                      )),
                ),
              ],
            ),
          )),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  void _handleTabSelection() {
    ref
        .read(currentVisitTabIndexState.notifier)
        .changeState(tabController.index);
  }
}
