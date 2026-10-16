import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'strings/cold_water_detail_strings.dart';
import 'strings/de/cold_water_detail_strings_de.dart';
import 'strings/de/electricity_detail_strings_de.dart';
import 'strings/de/gas_detail_strings_de.dart';
import 'strings/de/home_strings_de.dart';
import 'strings/de/hot_water_detail_strings_de.dart';
import 'strings/de/settings_strings_de.dart';
import 'strings/electricity_detail_strings.dart';
import 'strings/en/cold_water_detail_strings_en.dart';
import 'strings/en/electricity_detail_strings_en.dart';
import 'strings/en/gas_detail_strings_en.dart';
import 'strings/en/home_strings_en.dart';
import 'strings/en/hot_water_detail_strings_en.dart';
import 'strings/en/settings_strings_en.dart';
import 'strings/gas_detail_strings.dart';
import 'strings/home_strings.dart';
import 'strings/hot_water_detail_strings.dart';
import 'strings/settings_strings.dart';

class LanguageService extends ChangeNotifier {
  LanguageService(this._prefs)
    : _currentLanguageCode = _prefs.getString('language_code') ?? 'de';

  final SharedPreferences _prefs;
  String _currentLanguageCode;

  String get currentLanguageCode => _currentLanguageCode;
  Locale get currentLocale => Locale(_currentLanguageCode);
  bool get isGerman => _currentLanguageCode == 'de';
  bool get isEnglish => _currentLanguageCode == 'en';

  HomeStrings get homeStrings =>
      isGerman ? const HomeStringsDe() : const HomeStringsEn();

  SettingsStrings get settingsStrings =>
      isGerman ? const SettingsStringsDe() : const SettingsStringsEn();

  ColdWaterDetailStrings get coldWaterDetailStrings => isGerman
      ? const ColdWaterDetailStringsDe()
      : const ColdWaterDetailStringsEn();

  ElectricityDetailStrings get electricityDetailStrings => isGerman
      ? const ElectricityDetailStringsDe()
      : const ElectricityDetailStringsEn();

  GasDetailStrings get gasDetailStrings =>
      isGerman ? const GasDetailStringsDe() : const GasDetailStringsEn();

  HotWaterDetailStrings get hotWaterDetailStrings => isGerman
      ? const HotWaterDetailStringsDe()
      : const HotWaterDetailStringsEn();

  Future<void> setLanguage(String code) async {
    if (code == _currentLanguageCode) return;

    _currentLanguageCode = code;
    await _prefs.setString('language_code', code);
    notifyListeners();
  }
}
