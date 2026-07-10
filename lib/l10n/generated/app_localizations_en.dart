// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dashboard => 'Dashboard';

  @override
  String get inbound => 'Inbound';

  @override
  String get outbound => 'Outbound';

  @override
  String get inventory => 'Inventory';

  @override
  String get profile => 'Profile';

  @override
  String hello(String name) {
    return 'Hello, $name!';
  }

  @override
  String get todayStatus => 'Here is what\'s happening today.';

  @override
  String get pending => 'Pending';

  @override
  String get completed => 'Completed';

  @override
  String get inProgress => 'In Progress';

  @override
  String get alerts => 'Alerts';
}
