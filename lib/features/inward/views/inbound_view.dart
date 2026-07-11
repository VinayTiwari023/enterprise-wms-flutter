import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/viewmodels/theme_view_model.dart';
import '../viewmodels/inbound_view_model.dart';
import '../../../core/utils/base_view_model.dart';
import '../widgets/inward_widgets.dart';
import 'po_details_view.dart';

class InboundView extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  const InboundView({super.key, this.onBack});

  @override
  ConsumerState<InboundView> createState() => _InboundViewState();
}

class _InboundViewState extends ConsumerState<InboundView> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0;
  final List<String> _filters = ["All", "Pending", "Partial", "Completed"];

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
    final viewModel = ref.watch(inboundViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;

    final filteredList = viewModel.purchaseOrders.where((po) {
      String query = _searchController.text.toLowerCase();
      String filter = _filters[_selectedFilterIndex];
      bool matchesFilter = filter == "All" || po.status == filter;
      bool matchesSearch = po.poNumber.toLowerCase().contains(query) || 
                          po.supplier.toLowerCase().contains(query);
      return matchesFilter && matchesSearch;
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
                _buildFilterChips(primaryColor),
                const SizedBox(height: 20),
                Expanded(
                  child: viewModel.status == ViewStatus.loading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredList.isEmpty 
                      ? const Center(child: Text("No purchase orders found"))
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final po = filteredList[index];
                            return POCard(
                              po: po,
                              primaryColor: primaryColor,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PODetailsView(poNumber: po.poNumber)),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: InboundScanButton(primaryColor: primaryColor, onTap: () {}),
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
          "Inbound Operations",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.filter_list_rounded),
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
          hintText: "Search PO or Supplier...",
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildFilterChips(Color primaryColor) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          bool isSelected = _selectedFilterIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.grey.withValues(alpha: 0.2),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                _filters[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
