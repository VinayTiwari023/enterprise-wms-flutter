import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/theme_view_model.dart';
import '../../authentication/viewmodels/user_view_model.dart';
import '../widgets/settings_widgets.dart';
import '../../../shared/dialogs/logout_dialog.dart';

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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            floating: true,
            snap: true,
            leading: IconButton(
              onPressed: onBack ?? () {},
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            ),
            title: const Text(
              "My Profile",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  ProfileInfo(
                    name: "Vinay Kumar",
                    role: "Warehouse Manager",
                    initial: "V",
                    primaryColor: primaryColor,
                  ),
                  const SizedBox(height: 30),
                  _buildSectionTitle("Personal Information"),
                  const SizedBox(height: 10),
                  const InfoCard(
                      icon: Icons.badge_outlined,
                      label: "Employee ID",
                      value: "EMP-74829"),
                  InfoCard(
                      icon: Icons.email_outlined,
                      label: "Email",
                      value: userVM.user?.email ?? "vinay@wms-new.com"),
                  const InfoCard(
                      icon: Icons.phone_outlined,
                      label: "Phone",
                      value: "+91 9876543210"),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Warehouse Details"),
                  const SizedBox(height: 10),
                  const InfoCard(
                      icon: Icons.location_on_outlined,
                      label: "Primary Site",
                      value: "Bangalore Hub - WH1"),
                  const InfoCard(
                      icon: Icons.grid_view_rounded,
                      label: "Zone Assignment",
                      value: "Zone A, Zone B"),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Settings"),
                  const SizedBox(height: 10),
                  SettingToggle(
                    icon: Icons.wb_sunny_outlined,
                    title: "Dark Mode",
                    value: themeVM.isDarkMode,
                    onChanged: (val) => ref.read(themeViewModelProvider.notifier).toggleTheme(),
                    primaryColor: primaryColor,
                  ),
                  SettingLink(
                      icon: Icons.notifications_none_rounded,
                      title: "Notification Settings",
                      onTap: () {}),
                  SettingLink(
                      icon: Icons.lock_outline_rounded,
                      title: "Change Password",
                      onTap: () {}),
                  ListTile(
                    leading: Icon(Icons.language_rounded,
                        color: Colors.grey.shade400, size: 24),
                    title: const Text("Language",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    trailing: DropdownButton<String>(
                      value: themeVM.currentLocale.languageCode,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 'en', child: Text("English")),
                        DropdownMenuItem(value: 'hi', child: Text("हिंदी")),
                      ],
                      onChanged: (String? code) {
                        if (code != null) {
                          ref.read(themeViewModelProvider.notifier).setLocale(Locale(code));
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  LogoutButton(onTap: () async {
                    final confirmed = await showLogoutDialog(context);
                    if (confirmed == true) {
                      ref.read(userViewModelProvider.notifier).logout();
                    }
                  }),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
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
