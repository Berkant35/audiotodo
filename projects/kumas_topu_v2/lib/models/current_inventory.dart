


import 'package:kumas_topu/models/inventory_list.dart';
import 'package:kumas_topu/models/read_epc.dart';

class CurrentInventory {
  Inventory? inventory;
  List<ReadEpc>? readEpcList;
  Map<String, ReadEpc> readEpcMap;


  CurrentInventory({this.inventory, this.readEpcList,required this.readEpcMap });

  CurrentInventory copyWith({
    Inventory? inventory,
    List<ReadEpc>? readEpcList,
    required Map<String, ReadEpc> readEpcMap ,
  }) {
    return CurrentInventory(
      inventory: inventory,
      readEpcList: readEpcList,
      readEpcMap: readEpcMap
    );
  }

}