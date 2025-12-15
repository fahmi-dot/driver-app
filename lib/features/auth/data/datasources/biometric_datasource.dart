import 'dart:convert';
import 'dart:developer';

import 'package:driver_app/features/auth/data/models/biometric_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BiometricDataSource {
  Future<BiometricModel?> getBiometricSettings();
  Future<void> setBiometricSettings(BiometricModel biometric);
}

class BiometricDataSourceImpl implements BiometricDataSource {
  static const _key = 'biometric_settings';
  final SharedPreferences prefs;

  BiometricDataSourceImpl({required this.prefs});

  @override
  Future<BiometricModel?> getBiometricSettings() async {
    try {
      final settingsEncode = prefs.getString(_key);

      if (settingsEncode == null) return null;

      return BiometricModel.fromJson(jsonDecode(settingsEncode));
    } catch (e) {
      log('Error getting biometric settings: $e');
      return null;
    }
  }

  @override
  Future<void> setBiometricSettings(BiometricModel biometric) async {
    try {
      await prefs.setString(_key, jsonEncode(biometric.toJson()));
    } catch (e) {
      log('Error saving biometric settings: $e');
    }
  }
}