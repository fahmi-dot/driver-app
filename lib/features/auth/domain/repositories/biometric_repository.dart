import 'package:driver_app/features/auth/domain/entities/biometric.dart';

abstract class BiometricRepository {
  Future<Biometric> getBiometricSettings();
  Future<void> setBiometricSettings(Biometric biometric);
}