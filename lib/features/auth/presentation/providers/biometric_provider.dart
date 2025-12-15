import 'dart:async';

import 'package:driver_app/features/auth/data/datasources/biometric_datasource.dart';
import 'package:driver_app/features/auth/data/repositories/biometric_repository_impl.dart';
import 'package:driver_app/features/auth/domain/entities/biometric.dart';
import 'package:driver_app/features/auth/domain/repositories/biometric_repository.dart';
import 'package:driver_app/features/auth/domain/usecases/get_biometric_settings_usecase.dart';
import 'package:driver_app/features/auth/domain/usecases/set_biometric_settings_usecase.dart';
import 'package:driver_app/shared/providers/shared_preferences_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

final biometricDataSourceProvider = Provider<BiometricDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);

  return BiometricDataSourceImpl(prefs: prefs);
});

final biometricRepositoryProvider = Provider<BiometricRepository>((ref) {
  final datasource = ref.watch(biometricDataSourceProvider);

  return BiometricRepositoryImpl(biometricDataSource: datasource);
});

final getBiometricSettingsUseCaseProvider = Provider<GetBiometricSettingsUseCase>((ref) {
  final repository = ref.watch(biometricRepositoryProvider);

  return GetBiometricSettingsUseCase(repository);
});

final setBiometricSettingsUseCaseProvider = Provider<SetBiometricSettingsUseCase>((ref) {
  final repository = ref.watch(biometricRepositoryProvider);

  return SetBiometricSettingsUseCase(repository);
});

final biometricProvider = AsyncNotifierProvider<BiometricNotifier, Biometric>(
  BiometricNotifier.new
);

class BiometricNotifier extends AsyncNotifier<Biometric> {  
  final LocalAuthentication auth = LocalAuthentication();

  @override
  FutureOr<Biometric> build() {
    return _loadSettings();
  }

  Future<Biometric> _loadSettings() async {
    return getBiometricSettings();
  }

  Future<void> _saveSettings() async {
    final settings = state.value!;

    await ref.read(setBiometricSettingsUseCaseProvider).execute(settings);
  }

  void toggleIsEnable(bool isEnable) {
    final settings = state.value!;

    state = AsyncData(settings.copyWith(isEnable: isEnable));
    _saveSettings();
  }

  Future<Biometric> getBiometricSettings() async {
    state = AsyncLoading();

    try {
      Biometric settings = await ref.read(getBiometricSettingsUseCaseProvider).execute();

      if (settings.status == BiometricStatus.notChecked) {
        settings = await checkBiometricAvailability();
      }
      
      state = AsyncData(settings);
      return settings;
    } catch (e, stackTrace) {
      final settings = Biometric(
        isAvailable: false, 
        isFingerprintAvailable: false, 
        status: BiometricStatus.unsupported,
        isEnable: false,
      );
      state = AsyncError(e, stackTrace);
      return settings;
    }
  }

  Future<Biometric> checkBiometricAvailability() async {
    try {
      final canAuthWithBiometric = await auth.canCheckBiometrics;
      final canAuth = canAuthWithBiometric || await auth.isDeviceSupported();

      if (!canAuth) {
        final settings = Biometric(
          isAvailable: false, 
          isFingerprintAvailable: false, 
          status: BiometricStatus.notAvailable,
          isEnable: false,
        );

        state = AsyncData(settings);
        return settings;
      }

      final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

      if (availableBiometrics.isEmpty) {
        final settings = Biometric(
          isAvailable: false, 
          isFingerprintAvailable: false, 
          status: BiometricStatus.notEnrolled,
          isEnable: false,
        );

        state = AsyncData(settings);
        return settings;
      }

      final hasFingerprint = availableBiometrics.contains(BiometricType.fingerprint)
          || availableBiometrics.contains(BiometricType.strong)
          || availableBiometrics.contains(BiometricType.weak);

      final settings = Biometric(
        isAvailable: true, 
        isFingerprintAvailable: hasFingerprint, 
        status: BiometricStatus.available,
        isEnable: false,
      );

      state = AsyncData(settings);
      return settings;
    } on PlatformException catch (e, stackTrace) {
      final settings = Biometric(
        isAvailable: false, 
        isFingerprintAvailable: false, 
        status: BiometricStatus.unsupported,
        isEnable: false,
      );

      state = AsyncError(e, stackTrace);
      return settings;
    }
  }
  
  Future<bool> authenticate({
    required String reason,
    bool useErrorDialogs = true,
    bool stickyAuth = true,
  }) async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          biometricOnly: true,
        ),
      );

      return didAuthenticate;
    } on PlatformException {
      return false;
    }
  }
}