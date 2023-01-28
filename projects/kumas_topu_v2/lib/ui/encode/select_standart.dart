import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../line/global_providers.dart';
import '../../models/encode_standarts.dart';
import '../../utilities/components/select_drop.dart';

class SelectStandart extends ConsumerWidget {
  const SelectStandart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<EncodeStandarts?>(
        future: ref
            .read(viewModelStateProvider.notifier)
            .getEncodeStandarts(ref),
        builder: (context, snapshot)
        {
          var encodedStandarts = snapshot.data;
          var list = <String>[];
          var perStandart = PerStandart();
          if (encodedStandarts != null) {
            for (var element in encodedStandarts.data!) {
              list.add(element.encodeName!);
            }
          }

          if(list.length == 1){
            perStandart.encodeName = encodedStandarts!.data!.first.encodeName;
            perStandart.id = encodedStandarts.data!.first.id;

          }

          return ConnectionState.done == snapshot.connectionState
              ? SelectDrop(
            onSaved: (String value) {
              for (var standart in encodedStandarts!.data!) {
                if(standart.encodeName == value)
                {
                  perStandart.id = standart.id;
                  perStandart.encodeName = standart.encodeName;
                  ref
                      .read(currentBarcodeStandartProvider
                      .notifier)
                      .changeState(perStandart);
                }
              }
            },
            getList: list,
            dropTitle:
            ref.watch(currentBarcodeStandartProvider)?.encodeName ??
                'Standartlar',
            title: list.length != 1
                ? "Standart Seç"
                : "Kodlama Standartı",
          )
              : const CircularProgressIndicator();
        });
  }
}
