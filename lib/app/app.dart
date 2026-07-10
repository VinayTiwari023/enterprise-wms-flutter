import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/settings/viewmodels/theme_view_model.dart';
import '../l10n/generated/app_localizations.dart';
import '../features/authentication/views/splash_view.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeVM = ref.watch(themeViewModelProvider);
    
    return MaterialApp(
      title: 'WMS Modern App',
      debugShowCheckedModeBanner: false,
      theme: themeVM.themeData,
      locale: themeVM.currentLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SplashView(),
    );
  }
}
