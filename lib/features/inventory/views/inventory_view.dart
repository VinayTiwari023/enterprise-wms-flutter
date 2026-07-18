import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/viewmodels/theme_view_model.dart';
import '../models/inventory_item_model.dart';
import '../viewmodels/inventory_view_model.dart';
import '../../../core/enums/view_status.dart';
import '../../../shared/widgets/custom_sliver_delegate.dart';
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
    final themeState = ref.watch(themeViewModelProvider);
    final inventoryState = ref.watch(inventoryViewModelProvider);
    final primaryColor = themeState.currentThemeColor;

    List<InventoryItemModel> filteredList = inventoryState.items.where((item) {
      String query = _searchController.text.toLowerCase();
      return item.name.toLowerCase().contains(query) || 
             item.sku.toLowerCase().contains(query) ||
             item.location.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  onPressed: widget.onBack ?? () {},
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                ),
                title: const Text(
                  "Inventory",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                actions: [
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
              SliverPersistentHeader(
                pinned: true,
                delegate: PersistentHeaderDelegate(
                  minHeight: 70,
                  maxHeight: 70,
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: _buildSearchBar(context),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: inventoryState.status == ViewStatus.loading
                    ? const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : filteredList.isEmpty
                        ? const SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 100),
                                child: Text("No items found"),
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final item = filteredList[index];
                                return InventoryCard(item: item, primaryColor: primaryColor);
                              },
                              childCount: filteredList.length,
                            ),
                          ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
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
