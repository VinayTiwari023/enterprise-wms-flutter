import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/viewmodels/theme_view_model.dart';
import '../viewmodels/outbound_view_model.dart';
import '../../../core/enums/view_status.dart';
import '../../../shared/widgets/custom_sliver_delegate.dart';
import '../widgets/shipment_widgets.dart';

class OutboundView extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  const OutboundView({super.key, this.onBack});

  @override
  ConsumerState<OutboundView> createState() => _OutboundViewState();
}

class _OutboundViewState extends ConsumerState<OutboundView> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0;
  final List<String> _filters = ["All", "Pending", "Picking", "Shipped"];

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
    final outboundState = ref.watch(outboundViewModelProvider);
    final primaryColor = themeState.currentThemeColor;

    final filteredList = outboundState.orders.where((order) {
      String query = _searchController.text.toLowerCase();
      String filter = _filters[_selectedFilterIndex];
      bool matchesFilter = filter == "All" || order.status == filter;
      bool matchesSearch = order.orderNumber.toLowerCase().contains(query) || 
                          order.customer.toLowerCase().contains(query);
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
                leading: IconButton(
                  onPressed: widget.onBack ?? () {},
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                ),
                title: const Text(
                  "Outbound Shipping",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.tune_rounded),
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
              SliverPersistentHeader(
                pinned: true,
                delegate: PersistentHeaderDelegate(
                  minHeight: 60,
                  maxHeight: 60,
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: _buildFilterChips(primaryColor),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                sliver: outboundState.status == ViewStatus.loading
                    ? const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : filteredList.isEmpty
                        ? const SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 100),
                                child: Text("No orders found"),
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final order = filteredList[index];
                                return OrderCard(
                                  order: order,
                                  primaryColor: primaryColor,
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
            child: ManifestButton(primaryColor: primaryColor, onTap: () {}),
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
          hintText: "Search Order or Customer...",
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
