import 'package:driver_app/features/auth/domain/entities/biometric.dart';
import 'package:driver_app/features/auth/domain/repositories/biometric_repository.dart';

class GetBiometricSettingsUseCase {
  final BiometricRepository _biometricRepository;

  GetBiometricSettingsUseCase(this._biometricRepository);

  Future<Biometric> execute() async {
    return await _biometricRepository.getBiometricSettings();
  }
}