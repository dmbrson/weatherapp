import 'package:flutter/material.dart';


class AllLocales {
  AllLocales._();

  static final all = [
    const Locale("en", "US"),
    const Locale("ru", "RU"),
  ];

}
class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale("ru");

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!AllLocales.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = const Locale("ru");
    notifyListeners();
  }
}