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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Search RMA #, Order #, Customer...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
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
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                bool isSelected = _selectedFilterIndex == index;
                return ChoiceChip(
                  label: Text(_filters[index]),
                  selected: isSelected,
                  selectedColor: primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : null,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedFilterIndex = index);
                    }
                  },
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
