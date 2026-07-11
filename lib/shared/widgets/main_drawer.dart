import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/authentication/viewmodels/user_view_model.dart';
import '../../features/settings/viewmodels/theme_view_model.dart';


class MainDrawer extends ConsumerWidget {
  final int selectedIndex;
  final Function(int) onIndexSelected;
  const MainDrawer({super.key, required this.selectedIndex, required this.onIndexSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeVM = ref.watch(themeViewModelProvider);
    final userVM = ref.watch(userViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;

    return Drawer(
      backgroundColor: themeVM.isDarkMode ? const Color(0xFF1E1E26) : Colors.white,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(top: 60, left: 24, bottom: 24, right: 24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.4),
              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(50)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: primaryColor),
                ),
                const SizedBox(height: 16),
                Text(
                  userVM.user?.name ?? "User",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  userVM.user?.email ?? "user@wms-new.com",
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              children: [
                _sectionTitle("MAIN MENU"),
                _drawerItem(
                  Icons.grid_view_rounded, 
                  "Dashboard", 
                  isSelected: selectedIndex == 0, 
                  color: primaryColor,
                  onTap: () => onIndexSelected(0),
                ),
                _drawerItem(Icons.assignment_outlined, "My Task Queue", onTap: () {}),
                _drawerItem(
                  Icons.inventory_2_outlined, 
                  "Inventory Management", 
                  isSelected: selectedIndex == 3,
                  color: primaryColor,
                  onTap: () => onIndexSelected(3),
                ),
                _drawerItem(
                  Icons.login_rounded, 
                  "Inbound / Receiving", 
                  isSelected: selectedIndex == 1, 
                  color: primaryColor,
                  onTap: () => onIndexSelected(1),
                ),
                _drawerItem(
                  Icons.logout_rounded, 
                  "Outbound / Shipping", 
                  isSelected: selectedIndex == 2, 
                  color: primaryColor,
                  onTap: () => onIndexSelected(2),
                ),
                _drawerItem(
                  Icons.person_outline_rounded, 
                  "My Profile",
                  isSelected: selectedIndex == 4, 
                  color: primaryColor,
                  onTap: () => onIndexSelected(4),
                ),
                
                const SizedBox(height: 20),
                _sectionTitle("INSIGHTS"),
                _drawerItem(Icons.bar_chart_rounded, "Reports & Analytics", onTap: () {}),
                
                const SizedBox(height: 20),
                _sectionTitle("PERSONALIZATION"),
                SwitchListTile(
                  value: themeVM.isDarkMode,
                  onChanged: (val) => themeVM.toggleTheme(),
                  title: const Text("Dark Mode", style: TextStyle(fontSize: 14)),
                  secondary: Icon(themeVM.isDarkMode ? Icons.dark_mode : Icons.light_mode, size: 20),
                  activeThumbColor: primaryColor,
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text("Theme Color", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _colorOption(context, const Color(0xFF635BFF), themeVM), // Indigo
                      _colorOption(context, const Color(0xFF007BFF), themeVM), // Blue
                      _colorOption(context, const Color(0xFF00A86B), themeVM), // Green
                      _colorOption(context, const Color(0xFFD81B60), themeVM), // Pink
                      _colorOption(context, const Color(0xFFFF9800), themeVM), // Orange
                      _colorOption(context, const Color(0xFF9C27B0), themeVM), // Purple
                      _colorOption(context, const Color(0xFF00BCD4), themeVM), // Cyan
                      _colorOption(context, const Color(0xFF607D8B), themeVM), // Blue Grey
                    ],
                  ),
                ),
                
                const SizedBox(height: 10),
                _drawerItem(Icons.settings_outlined, "Settings", onTap: () {}),
              ],
            ),
          ),
          
          const Divider(height: 1),
          _drawerItem(Icons.logout_rounded, "Sign Out", textColor: Colors.redAccent, iconColor: Colors.redAccent, onTap: () {}),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, {bool isSelected = false, Color? color, Color? textColor, Color? iconColor, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? (color ?? Colors.blue).withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? color : (iconColor ?? Colors.grey[400]), size: 22),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? color : textColor,
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        dense: true,
        onTap: onTap,
      ),
    );
  }

  Widget _colorOption(BuildContext context, Color color, ThemeViewModel vm) {
    bool isSelected = vm.currentThemeColor == color;
    return GestureDetector(
      onTap: () => vm.setThemeColor(color),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: isSelected ? Colors.white : Colors.transparent, width: 2),
        ),
        child: isSelected ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
      ),
    );
  }
}
