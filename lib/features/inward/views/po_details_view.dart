import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../settings/viewmodels/theme_view_model.dart';
import '../widgets/inward_widgets.dart';

class PODetailsView extends ConsumerWidget {
  final String poNumber;
  const PODetailsView({super.key, required this.poNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("PO Details: $poNumber", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SupplierCard(),
                  const SizedBox(height: 30),
                  const Text(
                    "Items to Receive",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  ItemReceiveTile(title: "SKU Item #1000", required: "20", received: "0", onAdd: () {}),
                  ItemReceiveTile(title: "SKU Item #1001", required: "20", received: "0", onAdd: () {}),
                  ItemReceiveTile(title: "SKU Item #1002", required: "20", received: "0", onAdd: () {}),
                  ItemReceiveTile(title: "SKU Item #1003", required: "20", received: "0", onAdd: () {}),
                  ItemReceiveTile(title: "SKU Item #1004", required: "20", received: "0", onAdd: () {}),
                ],
              ),
            ),
          ),
          StartReceivingButton(primaryColor: primaryColor, onTap: () {}),
        ],
      ),
    );
  }
}
