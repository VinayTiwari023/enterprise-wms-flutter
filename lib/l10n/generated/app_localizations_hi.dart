// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get dashboard => 'डैशबोर्ड';

  @override
  String get inbound => 'इनबाउंड';

  @override
  String get outbound => 'आउटबाउंड';

  @override
  String get inventory => 'इन्वेंटरी';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String hello(String name) {
    return 'नमस्ते, $name!';
  }

  @override
  String get todayStatus => 'यहाँ आज क्या हो रहा है।';

  @override
  String get pending => 'लंबित';

  @override
  String get completed => 'पूरा हुआ';

  @override
  String get inProgress => 'प्रगति पर है';

  @override
  String get alerts => 'अलर्ट';
}
