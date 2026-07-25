import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../settings/viewmodels/theme_view_model.dart';
import '../../inward/viewmodels/inbound_view_model.dart';
import '../models/purchase_order_model.dart';
import '../../../core/enums/view_status.dart';
import '../../authentication/widgets/auth_widgets.dart';

class AddPOView extends ConsumerStatefulWidget {
  const AddPOView({super.key});

  @override
  ConsumerState<AddPOView> createState() => _AddPOViewState();
}

class _AddPOViewState extends ConsumerState<AddPOView> {
  final _formKey = GlobalKey<FormState>();
  final _supplierController = TextEditingController();
  final _itemsController = TextEditingController();
  late String _generatedPONumber;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _generatePONumber();
  }

  void _generatePONumber() {
    final year = DateTime.now().year;
    final random = Random().nextInt(9000) + 1000;
    _generatedPONumber = "PO-$year-$random";
  }

  @override
  void dispose() {
    _supplierController.dispose();
    _itemsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final po = PurchaseOrderModel(
        poNumber: _generatedPONumber,
        supplier: _supplierController.text,
        items: "0/${_itemsController.text}",
        date: DateFormat('d/M/yyyy').format(_selectedDate),
        status: "Pending",
        progress: 0.0,
      );

      final success = await ref.read(inboundViewModelProvider.notifier).addPO(po);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Purchase Order Created Successfully'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeVM = ref.watch(themeViewModelProvider);
    final inboundState = ref.watch(inboundViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;
    final isDark = themeVM.isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Accents
          Positioned(
            top: -100,
            right: -100,
            child: BackgroundCircle(size: 300, color: primaryColor),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: BackgroundCircle(size: 200, color: primaryColor),
          ),

          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                centerTitle: true,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                ),
                title: const Text(
                  "Create PO",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // PO Number Display Card
                        _buildPONumberCard(primaryColor, isDark),
                        const SizedBox(height: 32),
                        
                        _buildSectionLabel("SUPPLIER DETAILS"),
                        const SizedBox(height: 12),
                        _buildModernTextField(
                          controller: _supplierController,
                          hint: "Vendor Name (e.g. Acme Corp)",
                          icon: Icons.factory_outlined,
                          isDark: isDark,
                          primaryColor: primaryColor,
                          validator: (value) => value?.isEmpty ?? true ? "Please enter supplier name" : null,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        _buildSectionLabel("QUANTITY & LOGISTICS"),
                        const SizedBox(height: 12),
                        _buildModernTextField(
                          controller: _itemsController,
                          hint: "Total Expected Items",
                          icon: Icons.inventory_2_outlined,
                          isDark: isDark,
                          primaryColor: primaryColor,
                          keyboardType: TextInputType.number,
                          validator: (value) => value?.isEmpty ?? true ? "Please enter quantity" : null,
                        ),
                        
                        const SizedBox(height: 20),
                        _buildModernDatePicker(context, primaryColor, isDark),
                        
                        const SizedBox(height: 48),
                        
                        _buildSubmitButton(
                          inboundState.status == ViewStatus.loading, 
                          primaryColor
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Colors.grey.shade500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildPONumberCard(Color primaryColor, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Assigned PO Number",
            style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            _generatedPONumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "DRAFT STATUS",
              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isDark,
    required Color primaryColor,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E26) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(fontSize: 16, color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 15),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Icon(icon, color: Colors.grey, size: 22),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: primaryColor, width: 1.5),
          ),
          errorStyle: const TextStyle(height: 0),
        ),
      ),
    );
  }

  Widget _buildModernDatePicker(BuildContext context, Color primaryColor, bool isDark) {
    return InkWell(
      onTap: () => _pickDate(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E26) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_month_outlined, color: Colors.grey, size: 22),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Expected Delivery",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('MMMM d, yyyy').format(_selectedDate),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.edit_calendar_outlined, color: primaryColor, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(bool isLoading, Color primaryColor) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Text(
                "Finalize Purchase Order",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
