import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onToggleVisibility;
  final bool isDark;
  final Color primaryColor;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onToggleVisibility,
    required this.isDark,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
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
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        style: TextStyle(fontSize: 16, color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 16),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Icon(icon, color: Colors.grey, size: 22),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
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
        ),
      ),
    );
  }
}

class BackgroundCircle extends StatelessWidget {
  final double size;
  final Color color;

  const BackgroundCircle({super.key, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.2),
            color.withValues(alpha: 0.05),
          ],
        ),
      ),
    );
  }
}
