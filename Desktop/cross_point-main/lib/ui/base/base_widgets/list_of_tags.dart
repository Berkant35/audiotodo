import 'package:cross_point/layers/view_models/global_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/extensions/font_theme.dart';

class ListOfTags extends ConsumerWidget {
  const ListOfTags({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        reverse: true,
        itemCount: ref.watch(inventoryTagsProvider).length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  "${index + 1}. ${ref.watch(inventoryTagsProvider).values.toList()[index].epc!}",
                  style: ThemeValueExtension.subtitle,
                ),
                subtitle: Text(ref
                    .watch(inventoryTagsProvider)
                    .values
                    .toList()[index]
                    .epc!),
              ),
              const Divider(
                height: 2.0,
              ),
            ],
          );
        });
  }
}
