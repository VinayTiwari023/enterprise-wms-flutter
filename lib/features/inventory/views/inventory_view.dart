import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/viewmodels/theme_view_model.dart';
import '../models/inventory_item_model.dart';
import '../viewmodels/inventory_view_model.dart';
import '../../../core/utils/base_view_model.dart';
import '../widgets/inventory_widgets.dart';

class InventoryView extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  const InventoryView({super.key, this.onBack});

  @override
  ConsumerState<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends ConsumerState<InventoryView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeVM = ref.watch(themeViewModelProvider);
    final viewModel = ref.watch(inventoryViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;

    List<InventoryItemModel> filteredList = viewModel.items.where((item) {
      String query = _searchController.text.toLowerCase();
      return item.name.toLowerCase().contains(query) || 
             item.sku.toLowerCase().contains(query) ||
             item.location.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildHeader(context),
                const SizedBox(height: 20),
                _buildSearchBar(context),
                const SizedBox(height: 20),
                Expanded(
                  child: viewModel.status == ViewStatus.loading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredList.isEmpty 
                      ? const Center(child: Text("No items found"))
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final item = filteredList[index];
                            return InventoryCard(item: item, primaryColor: primaryColor);
                          },
                        ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: AddItemButton(primaryColor: primaryColor, onTap: () {}),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: widget.onBack ?? () {},
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        const Text(
          "Inventory",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.tune_rounded),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.sort_by_alpha_rounded),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search items, SKU, category...",
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
