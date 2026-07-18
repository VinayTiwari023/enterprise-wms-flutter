import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/viewmodels/theme_view_model.dart';
import '../viewmodels/tasks_view_model.dart';
import '../../../core/enums/view_status.dart';
import '../../../shared/widgets/custom_sliver_delegate.dart';
import '../widgets/task_widgets.dart';

class TaskQueueView extends ConsumerStatefulWidget {
  const TaskQueueView({super.key});

  @override
  ConsumerState<TaskQueueView> createState() => _TaskQueueViewState();
}

class _TaskQueueViewState extends ConsumerState<TaskQueueView> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0;
  final List<String> _filters = ["All", "High Priority", "Pending", "In Progress"];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref.read(tasksViewModelProvider.notifier).setSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeViewModelProvider);
    final tasksState = ref.watch(tasksViewModelProvider);
    final primaryColor = themeState.currentThemeColor;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            ),
            title: const Text(
              "My Task Queue",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => ref.read(tasksViewModelProvider.notifier).fetchTasks(),
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          
          // Pinned Search Bar
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

          // Pinned Filter Chips
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

          // Task List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: tasksState.status == ViewStatus.loading
                ? const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : tasksState.filteredTasks.isEmpty
                    ? const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: Text("No tasks found in your queue"),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final task = tasksState.filteredTasks[index];
                            return TaskCard(
                              task: task,
                              primaryColor: primaryColor,
                              onTap: () {},
                            );
                          },
                          childCount: tasksState.filteredTasks.length,
                        ),
                      ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
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
          hintText: "Search tasks or ID...",
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
            onTap: () {
              setState(() => _selectedFilterIndex = index);
              ref.read(tasksViewModelProvider.notifier).setFilter(_filters[index]);
            },
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
