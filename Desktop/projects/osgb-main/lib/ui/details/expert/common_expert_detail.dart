import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/ui/details/expert/expert_tab_views/customer_of_expert.dart';
import 'package:osgb/ui/details/expert/expert_tab_views/expert_info.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../custom_functions.dart';
import '../../../line/viewmodel/global_providers.dart';
import '../../../models/expert.dart';

import '../../../utilities/components/custom_flexible_bar.dart';

import '../../../utilities/constants/app/enums.dart';
import '../../../utilities/init/theme/custom_colors.dart';

class CommonExpertDetail extends ConsumerStatefulWidget {
  final Expert expert;

  const CommonExpertDetail({Key? key, required this.expert}) : super(key: key);

  @override
  ConsumerState createState() => _CommonExpertDetailState();
}

class _CommonExpertDetailState extends ConsumerState<CommonExpertDetail>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: ref.read(currentExpertDetailsTabIndexState));
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
      appBar: AppBar(
        leading: const SizedBox(),
        toolbarHeight: 30.h,
        flexibleSpace: CustomFlexibleBar(
          firstHeader: ref.watch(currentCustomFlexibleAppBarState).header1,
          secondHeader: ref.watch(currentCustomFlexibleAppBarState).header2,
          thirdHeader: ref.watch(currentCustomFlexibleAppBarState).header3,
          firstInfo: ref.watch(currentCustomFlexibleAppBarState).content1,
          secondInfo: ref.watch(currentCustomFlexibleAppBarState).content2,
          thirdInfo: ref.watch(currentCustomFlexibleAppBarState).content3,
          headerPhoto: ref.watch(currentCustomFlexibleAppBarState).photoUrl,
          appBarTitle: "Uzman Detay",
          role: Roles.expert,
        ),
      ),
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(2.0),
              child: SizedBox(
                child: TabBar(
                  isScrollable: true,
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.transparent,
                  indicatorWeight: CustomFunctions.isPhone() ? 1 : 5,
                  tabs: [
                    Tab(
                      child: Text(
                        'Detay',
                        style: ThemeValueExtension.subtitle3.copyWith(
                            color:
                            ref.watch(currentExpertDetailsTabIndexState) ==
                                0
                                ? CustomColors.secondaryColor
                                : Colors.black,
                            fontWeight:
                            ref.watch(currentExpertDetailsTabIndexState) ==
                                0
                                ? FontWeight.bold
                                : FontWeight.w500,
                            fontSize:
                            ref.watch(currentExpertDetailsTabIndexState) ==
                                0
                                ? ThemeValueExtension.subtitle2.fontSize
                                : ThemeValueExtension.subtitle3.fontSize),
                      ),
                    ),
                    Tab(
                      child: Text('Sorumlu İş Yerleri',
                          style: ThemeValueExtension.subtitle3.copyWith(
                              color: ref.watch(
                                  currentExpertDetailsTabIndexState) ==
                                  1
                                  ? CustomColors.secondaryColor
                                  : Colors.black,
                              fontWeight: ref.watch(
                                  currentExpertDetailsTabIndexState) ==
                                  1
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: ref.watch(
                                  currentExpertDetailsTabIndexState) ==
                                  1
                                  ? ThemeValueExtension.subtitle2.fontSize
                                  : ThemeValueExtension.subtitle3.fontSize)),
                    ),

                  ],
                ),
              )),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            ExpertInfo(
              expert: widget.expert,
            ),
            CustomerOfExpert(expert: widget.expert)
          ],
        ),
      ),
    );
  }

  void _handleTabSelection() {
    ref
        .read(currentExpertDetailsTabIndexState.notifier)
        .changeState(tabController.index);
  }
}
