import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/utilities/constants/extension/context_extensions.dart';

class InventoryMain extends ConsumerStatefulWidget {
  const InventoryMain({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _InventoryMainState();
}

class _InventoryMainState extends ConsumerState<InventoryMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sayım",
          style: ThemeValueExtension.subtitle,
        ),
      ),
    );
  }
}
