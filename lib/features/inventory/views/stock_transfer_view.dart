import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/enums/view_status.dart';
import '../../authentication/viewmodels/user_view_model.dart';
import '../../settings/viewmodels/theme_view_model.dart';
import '../models/inventory_item_model.dart';
import '../models/stock_transfer_model.dart';
import '../viewmodels/inventory_view_model.dart';
import '../viewmodels/stock_transfer_view_model.dart';

class StockTransferView extends ConsumerStatefulWidget {
  const StockTransferView({super.key});

  @override
  ConsumerState<StockTransferView> createState() => _StockTransferViewState();
}

class _StockTransferViewState extends ConsumerState<StockTransferView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _toLocationController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController(text: "1");

  final List<String> _transferReasons = [
    'Bin Consolidation',
    'Damaged Zone Movement',
    'Space Optimization',
    'High-Velocity Replenishment',
    'Audit Adjustment',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _toLocationController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;
    final userVM = ref.watch(userViewModelProvider);
    final transferState = ref.watch(stockTransferViewModelProvider);
    final inventoryItems = ref.watch(inventoryViewModelProvider).items;

    ref.listen<StockTransferState>(stockTransferViewModelProvider, (
      prev,
      next,
    ) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      if (next.successMessage != null && next.successMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: Colors.green,
          ),
        );
        _toLocationController.clear();
        _qtyController.text = "1";
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Bin-to-Bin Relocation",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: primaryColor,
          indicatorWeight: 3,
          tabs: const [
            Tab(icon: Icon(Icons.swap_horiz_rounded), text: "New Transfer"),
            Tab(icon: Icon(Icons.history_rounded), text: "Transfer History"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNewTransferTab(
            context,
            primaryColor,
            transferState,
            inventoryItems,
            userVM.user?.name ?? 'Operator',
          ),
          _buildHistoryTab(context, primaryColor, transferState.history),
        ],
      ),
    );
  }

  Widget _buildNewTransferTab(
    BuildContext context,
    Color primaryColor,
    StockTransferState transferState,
    List<InventoryItemModel> inventoryItems,
    String operatorName,
  ) {
    final selectedItem = transferState.selectedItem;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. SELECT ITEM TO RELOCATE
          _buildSectionHeader(
            "1. Select Item to Relocate",
            Icons.inventory_2_outlined,
            primaryColor,
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => _showSearchableItemPicker(
              context,
              primaryColor,
              inventoryItems,
              selectedItem,
            ),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selectedItem != null
                      ? primaryColor.withValues(alpha: 0.5)
                      : Colors.grey.withValues(alpha: 0.2),
                  width: selectedItem != null ? 1.5 : 1.0,
                ),
                boxShadow: [
                  if (selectedItem != null)
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.search_rounded,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: selectedItem == null
                        ? const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select Item to Relocate",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Tap to search by name, SKU, or bin location",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedItem.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withValues(
                                        alpha: 0.12,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "SKU: ${selectedItem.sku}",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withValues(
                                        alpha: 0.12,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "Bin: ${selectedItem.location}",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                  Icon(
                    Icons.unfold_more_rounded,
                    color: selectedItem != null ? primaryColor : Colors.grey,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 2. BIN RELOCATION FLOW VISUALIZER
          _buildSectionHeader(
            "2. Relocation Bins",
            Icons.swap_horizontal_circle_outlined,
            primaryColor,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // SOURCE BIN (Read-Only)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.output_rounded, color: primaryColor, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "SOURCE BIN (FROM)",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              transferState.fromLocation.isNotEmpty
                                  ? transferState.fromLocation
                                  : "Select an item above",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: transferState.fromLocation.isNotEmpty
                                    ? Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.color
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (selectedItem != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${selectedItem.units} Units",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // TRANSFER ARROW
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_downward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                // DESTINATION BIN INPUT
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.input_rounded,
                        color: Colors.green,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "DESTINATION BIN (TO)",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                letterSpacing: 0.5,
                              ),
                            ),
                            TextField(
                              controller: _toLocationController,
                              textCapitalization: TextCapitalization.characters,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                hintText: "E.g. B-04-12",
                                isDense: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                              ),
                              onChanged: (val) {
                                ref
                                    .read(
                                      stockTransferViewModelProvider.notifier,
                                    )
                                    .setToLocation(val);
                              },
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.qr_code_scanner_rounded,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          // Quick Bin Scan simulation
                          final sampleBins = [
                            'B-01-04',
                            'C-02-10',
                            'A-05-01',
                            'D-03-08',
                          ];
                          final scannedBin = (sampleBins..shuffle()).first;
                          _toLocationController.text = scannedBin;
                          ref
                              .read(stockTransferViewModelProvider.notifier)
                              .setToLocation(scannedBin);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 3. TRANSFER QUANTITY
          _buildSectionHeader(
            "3. Transfer Quantity",
            Icons.numbers_rounded,
            primaryColor,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Units to Move:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (transferState.quantity > 1) {
                          final newQ = transferState.quantity - 1;
                          _qtyController.text = newQ.toString();
                          ref
                              .read(stockTransferViewModelProvider.notifier)
                              .setQuantity(newQ);
                        }
                      },
                      icon: const Icon(
                        Icons.remove_circle_outline_rounded,
                        size: 28,
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: _qtyController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (val) {
                          final parsed = int.tryParse(val) ?? 1;
                          ref
                              .read(stockTransferViewModelProvider.notifier)
                              .setQuantity(parsed);
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        final maxAvailable = selectedItem?.units ?? 999;
                        if (transferState.quantity < maxAvailable) {
                          final newQ = transferState.quantity + 1;
                          _qtyController.text = newQ.toString();
                          ref
                              .read(stockTransferViewModelProvider.notifier)
                              .setQuantity(newQ);
                        }
                      },
                      icon: const Icon(
                        Icons.add_circle_outline_rounded,
                        size: 28,
                      ),
                    ),
                    if (selectedItem != null)
                      TextButton(
                        onPressed: () {
                          _qtyController.text = selectedItem.units.toString();
                          ref
                              .read(stockTransferViewModelProvider.notifier)
                              .setQuantity(selectedItem.units);
                        },
                        child: const Text("MAX"),
                      ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 4. REASON CHIPS
          _buildSectionHeader(
            "4. Relocation Reason",
            Icons.assignment_outlined,
            primaryColor,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _transferReasons.map((reason) {
              final isSelected = transferState.reason == reason;
              return ChoiceChip(
                label: Text(reason),
                selected: isSelected,
                selectedColor: primaryColor,
                labelStyle: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(stockTransferViewModelProvider.notifier)
                        .setReason(reason);
                  }
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // EXECUTE BUTTON
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              onPressed: transferState.status == ViewStatus.loading
                  ? null
                  : () {
                      ref
                          .read(stockTransferViewModelProvider.notifier)
                          .executeTransfer(operatorName);
                    },
              icon: transferState.status == ViewStatus.loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.check_circle_rounded, color: Colors.white),
              label: Text(
                transferState.status == ViewStatus.loading
                    ? "Processing Relocation..."
                    : "Confirm & Execute Relocation",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(
    BuildContext context,
    Color primaryColor,
    List<StockTransferModel> history,
  ) {
    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.history_toggle_off_rounded,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              "No Stock Transfers Executed Yet",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.id,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.status,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.itemName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "SKU: ${item.sku} • Reason: ${item.reason}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const Divider(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.swap_horiz_rounded,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${item.fromLocation} ➔ ${item.toLocation}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${item.quantity} Units",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "By: ${item.transferredBy}",
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    Text(
                      dateFormat.format(item.timestamp),
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSearchableItemPicker(
    BuildContext context,
    Color primaryColor,
    List<InventoryItemModel> inventoryItems,
    InventoryItemModel? selectedItem,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _SearchableItemPickerSheet(
          primaryColor: primaryColor,
          inventoryItems: inventoryItems,
          selectedItem: selectedItem,
          onItemSelected: (item) {
            ref.read(stockTransferViewModelProvider.notifier).selectItem(item);
          },
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _SearchableItemPickerSheet extends StatefulWidget {
  final Color primaryColor;
  final List<InventoryItemModel> inventoryItems;
  final InventoryItemModel? selectedItem;
  final ValueChanged<InventoryItemModel> onItemSelected;

  const _SearchableItemPickerSheet({
    required this.primaryColor,
    required this.inventoryItems,
    required this.selectedItem,
    required this.onItemSelected,
  });

  @override
  State<_SearchableItemPickerSheet> createState() =>
      __SearchableItemPickerSheetState();
}

class __SearchableItemPickerSheetState
    extends State<_SearchableItemPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  late List<InventoryItemModel> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.inventoryItems;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.inventoryItems;
      } else {
        _filteredItems = widget.inventoryItems.where((item) {
          final nameMatch = item.name.toLowerCase().contains(query);
          final skuMatch = item.sku.toLowerCase().contains(query);
          final locationMatch = item.location.toLowerCase().contains(query);
          return nameMatch || skuMatch || locationMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Title Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2_rounded,
                      color: widget.primaryColor,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Select Item to Relocate",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                  tooltip: "Close",
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Search by Name, SKU, or Bin Location...",
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: widget.primaryColor,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 20),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                filled: true,
                fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: widget.primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Result Count / Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${_filteredItems.length} item${_filteredItems.length == 1 ? '' : 's'} found",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          // Items List
          Expanded(
            child: _filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "No inventory items match your search",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final isSelected =
                          widget.selectedItem?.sku == item.sku &&
                          widget.selectedItem?.location == item.location;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? widget.primaryColor.withValues(alpha: 0.08)
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? widget.primaryColor
                                : Theme.of(context).colorScheme.outline,
                            width: isSelected ? 2.0 : 1.0,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            widget.onItemSelected(item);
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? widget.primaryColor
                                        : widget.primaryColor.withValues(
                                            alpha: 0.1,
                                          ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isSelected
                                        ? Icons.check_rounded
                                        : Icons.inventory_2_outlined,
                                    color: isSelected
                                        ? Colors.white
                                        : widget.primaryColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: isSelected
                                              ? widget.primaryColor
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            "SKU: ${item.sku}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "•  Bin: ${item.location}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: widget.primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: widget.primaryColor.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "${item.units} units",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: widget.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
