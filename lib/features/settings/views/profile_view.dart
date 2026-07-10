import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/theme_view_model.dart';
import '../../authentication/viewmodels/user_view_model.dart';
import '../widgets/settings_widgets.dart';

class ProfileView extends ConsumerWidget {
  final VoidCallback? onBack;
  const ProfileView({super.key, this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeVM = ref.watch(themeViewModelProvider);
    final userVM = ref.watch(userViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildHeader(context),
            const SizedBox(height: 20),
            ProfileInfo(
              name: "Vinay Kumar",
              role: "Warehouse Manager",
              initial: "V",
              primaryColor: primaryColor,
            ),
            const SizedBox(height: 30),
            _buildSectionTitle("Personal Information"),
            const SizedBox(height: 10),
            const InfoCard(icon: Icons.badge_outlined, label: "Employee ID", value: "EMP-74829"),
            InfoCard(icon: Icons.email_outlined, label: "Email", value: userVM.user?.email ?? "vinay@wms-new.com"),
            const InfoCard(icon: Icons.phone_outlined, label: "Phone", value: "+91 9876543210"),
            const SizedBox(height: 25),
            _buildSectionTitle("Warehouse Details"),
            const SizedBox(height: 10),
            const InfoCard(icon: Icons.location_on_outlined, label: "Primary Site", value: "Bangalore Hub - WH1"),
            const InfoCard(icon: Icons.grid_view_rounded, label: "Zone Assignment", value: "Zone A, Zone B"),
            const SizedBox(height: 25),
            _buildSectionTitle("Settings"),
            const SizedBox(height: 10),
            SettingToggle(
              icon: Icons.wb_sunny_outlined,
              title: "Dark Mode",
              value: themeVM.isDarkMode,
              onChanged: (val) => themeVM.toggleTheme(),
              primaryColor: primaryColor,
            ),
            SettingLink(icon: Icons.notifications_none_rounded, title: "Notification Settings", onTap: () {}),
            SettingLink(icon: Icons.lock_outline_rounded, title: "Change Password", onTap: () {}),
            ListTile(
              leading: Icon(Icons.language_rounded, color: Colors.grey.shade400, size: 24),
              title: const Text("Language", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              trailing: DropdownButton<String>(
                value: themeVM.currentLocale.languageCode,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'en', child: Text("English")),
                  DropdownMenuItem(value: 'hi', child: Text("हिंदी")),
                ],
                onChanged: (String? code) {
                  if (code != null) {
                    themeVM.setLocale(Locale(code));
                  }
                },
              ),
            ),
            const SizedBox(height: 30),
            LogoutButton(onTap: () {}),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onBack ?? () {},
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        const Text(
          "My Profile",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 48), // Spacer to balance the back button
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
