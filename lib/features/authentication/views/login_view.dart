import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/helpers/responsive_helper.dart';
import '../viewmodels/login_view_model.dart';
import '../../../core/utils/base_view_model.dart';
import '../../settings/viewmodels/theme_view_model.dart';
import '../viewmodels/user_view_model.dart';
import '../../../shared/models/user_model.dart';
import '../../dashboard/views/home_view.dart';
import '../widgets/auth_widgets.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeVM = ref.watch(themeViewModelProvider);
    final viewModel = ref.watch(loginViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;
    final isDark = themeVM.isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
                // Top Left Circle
                Positioned(
                  top: -ResponsiveHelper.responsiveSize(context, 80, 100, 120),
                  left: -ResponsiveHelper.responsiveSize(context, 80, 100, 120),
                  child: BackgroundCircle(
                      size: ResponsiveHelper.responsiveSize(context, 250, 350, 450),
                      color: primaryColor),
                ),
                // Bottom Right Circle
                Positioned(
                  bottom: -ResponsiveHelper.responsiveSize(context, 100, 150, 200),
                  right: -ResponsiveHelper.responsiveSize(context, 80, 100, 120),
                  child: BackgroundCircle(
                      size: ResponsiveHelper.responsiveSize(context, 300, 450, 550),
                      color: primaryColor),
                ),
                
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: ResponsiveHelper.responsiveHorizontalPadding(context).add(
                        const EdgeInsets.symmetric(horizontal: 20)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Lock Icon
                          Icon(
                            Icons.lock_person_rounded,
                            size: ResponsiveHelper.responsiveSize(context, 60, 80, 100),
                            color: primaryColor,
                          ),
                          
                          SizedBox(height: ResponsiveHelper.responsiveSpacing(context) * 2),
                          
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Welcome Back",
                              style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(context, 26, 32, 40),
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF2D2D2D),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          
                          SizedBox(height: ResponsiveHelper.responsiveSpacing(context)),
                          
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: const Text(
                              "Enter your credentials to continue",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          
                          SizedBox(height: ResponsiveHelper.responsiveSpacing(context) * 4),
                          
                          // Email Field
                          AuthTextField(
                            controller: _emailController,
                            hint: "Email",
                            icon: Icons.email_outlined,
                            isDark: isDark,
                            primaryColor: primaryColor,
                          ),
                          
                          SizedBox(height: ResponsiveHelper.responsiveSpacing(context) * 2),
                          
                          // Password Field
                          AuthTextField(
                            controller: _passwordController,
                            hint: "Password",
                            icon: Icons.lock_outline_rounded,
                            isPassword: true,
                            isPasswordVisible: viewModel.isPasswordVisible,
                            onToggleVisibility: viewModel.togglePasswordVisibility,
                            isDark: isDark,
                            primaryColor: primaryColor,
                          ),
                          
                          SizedBox(height: ResponsiveHelper.responsiveSpacing(context) * 4),
                          
                          // Login Button
                          viewModel.status == ViewStatus.loading
                            ? CircularProgressIndicator(color: primaryColor)
                            : Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    UserModel? user = await viewModel.login(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                    if (viewModel.status == ViewStatus.success && user != null) {
                                      if (mounted) {
                                        // Save user to session
                                        ref.read(userViewModelProvider).setUser(user);

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Login Successful')),
                                        );
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (_) => const HomeView()),
                                        );
                                      }
                                    } else if (viewModel.status == ViewStatus.error) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(viewModel.errorMessage ?? 'Login Failed'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(double.infinity, ResponsiveHelper.responsiveSize(context, 50, 60, 70)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.responsiveFontSize(context, 16, 18, 20), 
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                          
                          SizedBox(height: ResponsiveHelper.responsiveSpacing(context) * 3),
                          
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: isDark ? Colors.white70 : const Color(0xFF4A4A4A),
                                fontWeight: FontWeight.w600,
                                fontSize: ResponsiveHelper.responsiveFontSize(context, 13, 15, 17),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
