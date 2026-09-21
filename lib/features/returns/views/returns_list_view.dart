import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../settings/viewmodels/theme_view_model.dart';
import '../viewmodels/returns_view_model.dart';
import '../widgets/return_widgets.dart';
import '../../../core/enums/view_status.dart';

class ReturnsListView extends ConsumerStatefulWidget {
  const ReturnsListView({super.key});

  @override
  ConsumerState<ReturnsListView> createState() => _ReturnsListViewState();
}

class _ReturnsListViewState extends ConsumerState<ReturnsListView> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0;
  final List<String> _filters = [
    "All",
    "Pending Inspection",
    "Inspected",
    "Processed",
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeVM = ref.watch(themeViewModelProvider);
    final returnsState = ref.watch(returnsViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;

    final filteredList = returnsState.returns.where((rma) {
      String query = _searchController.text.toLowerCase();
      String filter = _filters[_selectedFilterIndex];
      bool matchesFilter = filter == "All" || rma.status == filter;
      bool matchesSearch =
          rma.rmaNumber.toLowerCase().contains(query) ||
          rma.originalOrderNumber.toLowerCase().contains(query) ||
          rma.customerName.toLowerCase().contains(query);
      return matchesFilter && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Returns & RMA Logistics",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(RouteNames.createRMA),
            icon: const Icon(Icons.add, size: 24),
            tooltip: "Create RMA",
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: themeVM.isDarkMode
                    ? Colors.grey.shade800
                    : Colors.grey.shade300,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Search RMA #, Order #, Customer...",
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                prefixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.search_rounded,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                bool isSelected = _selectedFilterIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilterIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? primaryColor
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? primaryColor
                            : (themeVM.isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade300),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _filters[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: returnsState.status == ViewStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : filteredList.isEmpty
                ? const Center(
                    child: Text(
                      "No return orders found.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: filteredList.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final returnOrder = filteredList[index];
                      return ReturnOrderCard(
                        returnOrder: returnOrder,
                        primaryColor: primaryColor,
                        onTap: () {
                          context.pushNamed(
                            RouteNames.returnDetails,
                            pathParameters: {
                              'rmaNumber': returnOrder.rmaNumber,
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
