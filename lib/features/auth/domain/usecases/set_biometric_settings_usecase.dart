import 'package:driver_app/features/auth/domain/entities/biometric.dart';
import 'package:driver_app/features/auth/domain/repositories/biometric_repository.dart';

class SetBiometricSettingsUseCase {
  final BiometricRepository _biometricRepository;

  SetBiometricSettingsUseCase(this._biometricRepository);

  Future<void> execute(Biometric biometric) async {
    await _biometricRepository.setBiometricSettings(biometric);
  }
}