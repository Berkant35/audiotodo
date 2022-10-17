
import 'package:cross_point/layers/view_models/global_providers.dart';
import 'package:cross_point/layers/view_models/view_model.dart';
import 'package:cross_point/ui/base/inventory_of_items.dart';
import 'package:cross_point/utilities/constants/enums.dart';
import 'package:cross_point/utilities/extensions/context_extension.dart';
import 'package:cross_point/utilities/navigation/navigation_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../layers/models/location_model.dart';
import '../../utilities/constants/custom_colors.dart';
import '../../utilities/extensions/EdgeExtension.dart';
import '../../utilities/extensions/font_theme.dart';
import '../../utilities/extensions/iconSizeExtension.dart';
import '../../utilities/navigation/navigation_service.dart';

class LocationSearch extends ConsumerStatefulWidget {
  const LocationSearch({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _LocationSearchState();
}

class _LocationSearchState extends ConsumerState<LocationSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.crossPointDark,
        leading: IconButton(
          onPressed: () {
            NavigationService.instance.navigatePopUp();
          },
          icon: Icon(
            Icons.arrow_back,
            size: IconSizeExtension.HIGH.sizeValue,
          ),
        ),
        toolbarHeight: context.height * 0.08,
        title: Text(
          "Choose Location",
          style: ThemeValueExtension.subtitle,
        ),
        actions: [
          FutureBuilder<Locations?>(
              future: ref.read(viewModelStateProvider.notifier).getLocations(),
              builder: (context, snapshot) {
                Locations? snapshotData = snapshot.data;
                List<Location>? locationList = snapshotData?.data;
                return snapshot.connectionState == ConnectionState.done
                    ? snapshot.data != null
                        ? Padding(
                            padding: EdgeInsets.only(
                                right: EdgeExtension.lowEdge.edgeValue),
                            child: IconButton(
                              onPressed: () {
                                showSearch(
                                    context: context,
                                    delegate: CustomSearchDelegate(
                                        locationList: locationList,ref: ref));
                              },
                              icon: Icon(
                                Icons.search,
                                size: IconSizeExtension.HIGH.sizeValue,
                              ),
                            ),
                          )
                        : const SizedBox()
                    : const SizedBox();
              })
        ],
      ),
      body: SizedBox(
        child: FutureBuilder<Locations?>(
          future: ref.read(viewModelStateProvider.notifier).getLocations(),
          builder: (context, snapshot) {
            Locations? snapshotData = snapshot.data;
            List<Location>? locationList = snapshotData?.data!;
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.data != null && locationList != null
                    ? Padding(
                        padding: EdgeInsets.only(top: context.lowValue),
                        child: ListView.builder(
                            itemCount: locationList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return perRowInfo(context, locationList[index]);
                            }),
                      )
                    : Center(
                        child: SizedBox(
                        child: Text(
                          'No location!',
                          style: ThemeValueExtension.subtitle,
                        ),
                      ))
                : const Center(child: CircularProgressIndicator.adaptive());
          },
        ),
      ),
    );
  }

  Future<void> buildNavigateToPage(Location location) {
    String path = NavigationConstants.inventoryOfItems;
    if(ref.read(operationStatusStateProvider) == OperationStatus.INVENTORYLIST){
      path = NavigationConstants.inventoryListOfLocationPage;
    }
    return NavigationService.instance.navigateToPage(
        path: path,
        data: {"locationName": location.name, "locationID": location.id});
  }

  GestureDetector perRowInfo(BuildContext context, Location location) {
    return GestureDetector(
      onTap: () {
        buildNavigateToPage(location);
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(context.lowValue),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: context.lowValue,
                      ),
                      Icon(
                        Icons.dry_cleaning,
                        color: CustomColors.crossPointLight,
                        size: IconSizeExtension.HIGH.sizeValue,
                      ),
                      SizedBox(
                        width: context.lowValue,
                      ),
                      Text(location.name!,
                          style: ThemeValueExtension.subtitle2),
                      SizedBox(
                        width: context.lowValue,
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: CustomColors.crossPointLight,
                        borderRadius: BorderRadius.all(
                            Radius.circular(EdgeExtension.lowEdge.edgeValue))),
                    child: Padding(
                      padding: EdgeInsets.all(context.lowValue),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Choose',
                            style: ThemeValueExtension.subtitle3.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: context.lowValue,
                          ),
                          Icon(
                            Icons.arrow_right_alt_sharp,
                            color: Colors.white,
                            size: IconSizeExtension.HIGH.sizeValue,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<Location>? locationList;
  WidgetRef ref;
  CustomSearchDelegate({required this.locationList,required this.ref});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear, size: IconSizeExtension.HIGH.sizeValue),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back, size: IconSizeExtension.HIGH.sizeValue),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    List<Location> lopaQuery = [];

    for (var location in locationList!) {
      if (location.name!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(location.name!);
        lopaQuery.add(location);
      }
    }

    return Padding(
      padding: EdgeInsets.only(
          top: EdgeExtension.lowEdge.edgeValue,
          left: EdgeExtension.lowEdge.edgeValue),
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var location = locationList![index];

          return GestureDetector(
            onTap: () {
              buildNavigateToPage(location);
            },
            child: Container(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lopaQuery[index].name!,
                      style: ThemeValueExtension.subtitle2),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: EdgeExtension.lowEdge.edgeValue),
                    child: const Divider(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> buildNavigateToPage(Location location) {
    String path = NavigationConstants.inventoryOfItems;
    if(ref.read(operationStatusStateProvider) == OperationStatus.INVENTORYLIST){
      path = NavigationConstants.inventoryListOfLocationPage;
    }
    return NavigationService.instance.navigateToPage(
        path: path,
        data: {"locationName": location.name, "locationID": location.id});
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    List<Location> lopaQuery = [];
    for (var location in locationList!) {
      if (location.name!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(location.name!);
        lopaQuery.add(location);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var location = locationList![index];

        return ListTile(
          title: GestureDetector(
              onTap: () {
                buildNavigateToPage(location);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lopaQuery[index].name!,
                      style: ThemeValueExtension.subtitle2),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: EdgeExtension.lowEdge.edgeValue),
                    child: const Divider(),
                  ),
                ],
              )),
        );
      },
    );
  }
}
