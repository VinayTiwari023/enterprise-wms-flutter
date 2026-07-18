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
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                floating: true,
                snap: true,
                leading: IconButton(
                  onPressed: widget.onBack ?? () {},
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                ),
                title: const Text(
                  "Inbound Operations",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list_rounded),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                sliver: SliverToBoxAdapter(
                  child: _buildSearchBar(context),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                sliver: SliverToBoxAdapter(
                  child: _buildFilterChips(primaryColor),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                sliver: viewModel.status == ViewStatus.loading
                    ? const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : filteredList.isEmpty
                        ? const SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 100),
                                child: Text("No purchase orders found"),
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final po = filteredList[index];
                                return POCard(
                                  po: po,
                                  primaryColor: primaryColor,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PODetailsView(poNumber: po.poNumber)),
                                    );
                                  },
                                );
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
            child: InboundScanButton(primaryColor: primaryColor, onTap: () {}),
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
