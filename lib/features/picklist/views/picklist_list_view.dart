import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../settings/viewmodels/theme_view_model.dart';
import '../viewmodels/picklist_view_model.dart';
import '../widgets/picklist_widgets.dart';
import '../../../core/enums/view_status.dart';

class PicklistListView extends ConsumerStatefulWidget {
  const PicklistListView({super.key});

  @override
  ConsumerState<PicklistListView> createState() => _PicklistListViewState();
}

class _PicklistListViewState extends ConsumerState<PicklistListView> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0;
  final List<String> _filters = ["All", "Pending", "In Progress", "Completed"];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeVM = ref.watch(themeViewModelProvider);
    final picklistState = ref.watch(picklistViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;

    final filteredList = picklistState.picklists.where((pl) {
      String query = _searchController.text.toLowerCase();
      String filter = _filters[_selectedFilterIndex];
      bool matchesFilter = filter == "All" || pl.status == filter;
      bool matchesSearch =
          pl.waveNumber.toLowerCase().contains(query) ||
          pl.id.toLowerCase().contains(query) ||
          pl.assignedPicker.toLowerCase().contains(query);
      return matchesFilter && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wave & Batch Picklists",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(picklistViewModelProvider.notifier).createWavePicklist();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("New Wave Picklist Generated!")),
              );
            },
            icon: const Icon(Icons.add_task_rounded),
            tooltip: "Generate New Wave",
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
                hintText: "Search Wave #, ID, or Picker...",
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
            child: picklistState.status == ViewStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : filteredList.isEmpty
                ? const Center(
                    child: Text(
                      "No picklists found.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: filteredList.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final picklist = filteredList[index];
                      return PicklistCard(
                        picklist: picklist,
                        primaryColor: primaryColor,
                        onTap: () {
                          context.pushNamed(
                            RouteNames.picklistDetails,
                            pathParameters: {'id': picklist.id},
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
