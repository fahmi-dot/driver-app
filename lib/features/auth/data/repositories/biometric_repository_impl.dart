import 'package:driver_app/features/auth/data/datasources/biometric_datasource.dart';
import 'package:driver_app/features/auth/data/models/biometric_model.dart';
import 'package:driver_app/features/auth/domain/entities/biometric.dart';
import 'package:driver_app/features/auth/domain/repositories/biometric_repository.dart';

class BiometricRepositoryImpl implements BiometricRepository {
  final BiometricDataSource biometricDataSource;

  BiometricRepositoryImpl({required this.biometricDataSource});

  @override
  Future<Biometric> getBiometricSettings() async {
    final biometricModel = await biometricDataSource.getBiometricSettings();

    if (biometricModel != null) return biometricModel.toEntity();
    
    return Biometric(
      isAvailable: false, 
      isFingerprintAvailable: false, 
      status: BiometricStatus.notChecked, 
      isEnable: false,
    );
  }

  @override
  Future<void> setBiometricSettings(Biometric biometric) async {
    await biometricDataSource.setBiometricSettings(BiometricModel.fromEntity(biometric));
  }
}