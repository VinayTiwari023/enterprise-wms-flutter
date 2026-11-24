import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/audio_haptic_service.dart';
import '../../dashboard/views/home_view.dart';
import '../viewmodels/theme_view_model.dart';
import '../../authentication/viewmodels/user_view_model.dart';
import '../widgets/settings_widgets.dart';
import '../../../shared/dialogs/logout_dialog.dart';
import '../../../shared/widgets/searchable_dropdown.dart';

class ProfileView extends ConsumerWidget {
  final VoidCallback? onBack;
  const ProfileView({super.key, this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeVM = ref.watch(themeViewModelProvider);
    final userVM = ref.watch(userViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            pinned: true,
            floating: true,
            snap: true,
            leading: IconButton(
              onPressed: () {
                ref.read(shouldOpenDrawerProvider.notifier).state = true;
                if (onBack != null) {
                  onBack!();
                } else if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  context.go('/dashboard');
                }
              },
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
                    value: "EMP-74829",
                  ),
                  InfoCard(
                    icon: Icons.email_outlined,
                    label: "Email",
                    value: userVM.user?.email ?? "vinay@wms-new.com",
                  ),
                  const InfoCard(
                    icon: Icons.phone_outlined,
                    label: "Phone",
                    value: "+91 9876543210",
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Warehouse Details"),
                  const SizedBox(height: 10),
                  const InfoCard(
                    icon: Icons.location_on_outlined,
                    label: "Primary Site",
                    value: "Bangalore Hub - WH1",
                  ),
                  const InfoCard(
                    icon: Icons.grid_view_rounded,
                    label: "Zone Assignment",
                    value: "Zone A, Zone B",
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Hardware & Scanner Settings"),
                  const SizedBox(height: 10),
                  Consumer(
                    builder: (context, ref, _) {
                      final audioHaptic = ref.watch(audioHapticServiceProvider);
                      return Column(
                        children: [
                          SettingToggle(
                            icon: Icons.volume_up_outlined,
                            title: "Scan Audio Sound Beep",
                            value: audioHaptic.isAudioEnabled,
                            onChanged: (val) {
                              audioHaptic.isAudioEnabled = val;
                              if (val) audioHaptic.playSuccessFeedback();
                            },
                            primaryColor: primaryColor,
                          ),
                          SettingToggle(
                            icon: Icons.vibration_rounded,
                            title: "Scan Haptic Vibration",
                            value: audioHaptic.isHapticEnabled,
                            onChanged: (val) {
                              audioHaptic.isHapticEnabled = val;
                              if (val) audioHaptic.playSuccessFeedback();
                            },
                            primaryColor: primaryColor,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.qr_code_scanner_rounded,
                              color: primaryColor,
                              size: 24,
                            ),
                            title: const Text(
                              "Hardware Laser Scanner",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: const Text(
                              "Zebra DataWedge & Honeywell Intent Ready",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green),
                              ),
                              child: const Text(
                                "ACTIVE",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Settings"),
                  const SizedBox(height: 10),
                  SettingToggle(
                    icon: Icons.wb_sunny_outlined,
                    title: "Dark Mode",
                    value: themeVM.isDarkMode,
                    onChanged: (val) =>
                        ref.read(themeViewModelProvider.notifier).toggleTheme(),
                    primaryColor: primaryColor,
                  ),
                  SettingLink(
                    icon: Icons.notifications_none_rounded,
                    title: "Notification Settings",
                    onTap: () {},
                  ),
                  SettingLink(
                    icon: Icons.lock_outline_rounded,
                    title: "Change Password",
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.language_rounded,
                      color: Colors.grey.shade400,
                      size: 24,
                    ),
                    title: const Text(
                      "Language",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: SizedBox(
                      width: 130,
                      child: SearchableDropdown<String>(
                        value: themeVM.currentLocale.languageCode,
                        hintText: "Language",
                        modalTitle: "Select Language",
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        items: const ['en', 'hi'],
                        itemLabel: (code) =>
                            code == 'en' ? "English" : "हिंदी (Hindi)",
                        itemIcon: (code) => Icon(
                          code == 'en'
                              ? Icons.language_rounded
                              : Icons.translate_rounded,
                          size: 18,
                          color: primaryColor,
                        ),
                        onChanged: (String? code) {
                          if (code != null) {
                            ref
                                .read(themeViewModelProvider.notifier)
                                .setLocale(Locale(code));
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  LogoutButton(
                    onTap: () async {
                      final confirmed = await showLogoutDialog(context);
                      if (confirmed == true) {
                        ref.read(userViewModelProvider.notifier).logout();
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/icons/wms_icon.png',
                            width: 48,
                            height: 48,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "WMS Enterprise",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Version 1.0.0 (Build 100)",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
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
