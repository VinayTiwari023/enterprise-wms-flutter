import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../settings/viewmodels/theme_view_model.dart';

class ShowcaseTourModal extends ConsumerStatefulWidget {
  const ShowcaseTourModal({super.key});

  static void show(BuildContext context) {
    showDialog(context: context, builder: (_) => const ShowcaseTourModal());
  }

  @override
  ConsumerState<ShowcaseTourModal> createState() => _ShowcaseTourModalState();
}

class _ShowcaseTourModalState extends ConsumerState<ShowcaseTourModal> {
  int _currentStep = 0;

  static const List<Map<String, dynamic>> _steps = [
    {
      'title': '📦 Inbound PO Receiving & Barcode Scan',
      'icon': Icons.login_rounded,
      'desc':
          'Receive vendor purchase orders, scan items using mobile scanner, report damaged goods, and execute directed putaway to designated storage bins.',
    },
    {
      'title': '⚡ Wave Picklists & Guided Sequential Routes',
      'icon': Icons.route_rounded,
      'desc':
          'Batch multiple sales orders into optimized Wave Picklists. Pickers follow guided sequential route stops sorted by bin coordinates.',
    },
    {
      'title': '📍 Bin-to-Bin Relocation & Inventory',
      'icon': Icons.swap_horiz_rounded,
      'desc':
          'Perform Bin-to-Bin relocations using a searchable item selector. Live inventory updates automatically upon stock movements.',
    },
    {
      'title': '🗄️ Master Data & Multi-Warehouse Hubs',
      'icon': Icons.storage_rounded,
      'desc':
          'Manage Pickers, Loaders, SKUs, Bins, and Suppliers with Indian entity names. Switch active sites between Mumbai, Delhi, and Bengaluru hubs.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;
    final stepData = _steps[_currentStep];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    stepData['icon'] as IconData,
                    color: primaryColor,
                    size: 26,
                  ),
                ),
                Text(
                  "Step ${_currentStep + 1} of ${_steps.length}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              stepData['title'] as String,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              stepData['desc'] as String,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Step Indicator Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _steps.length,
                (idx) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentStep == idx ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentStep == idx
                        ? primaryColor
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Navigation Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  TextButton(
                    onPressed: () => setState(() => _currentStep--),
                    child: const Text("Previous"),
                  )
                else
                  const SizedBox.shrink(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_currentStep < _steps.length - 1) {
                      setState(() => _currentStep++);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    _currentStep < _steps.length - 1 ? "Next" : "Got It!",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
