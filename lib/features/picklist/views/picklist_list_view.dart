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
        centerTitle: true,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Search Wave #, ID, or Picker...",
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
