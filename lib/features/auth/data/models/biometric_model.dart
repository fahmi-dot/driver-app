import 'package:driver_app/features/auth/domain/entities/biometric.dart';

class BiometricModel extends Biometric {
  BiometricModel({
    required super.isAvailable,
    required super.isFingerprintAvailable,
    required super.status,
    required super.isEnable,
  });

  factory BiometricModel.fromJson(Map<String, dynamic> json) {
    return BiometricModel(
      isAvailable: json['isAvailable'] ?? json['available'],
      isFingerprintAvailable: json['isFingerprintAvailable'] ?? json['fingerprintAvailable'],
      status: BiometricStatus.values.byName(json['status']),
      isEnable: json['isEnable'] ?? json['enable'],
    );
  }

  factory BiometricModel.fromEntity(Biometric biometric) {
    return BiometricModel(
      isAvailable: biometric.isAvailable,
      isFingerprintAvailable: biometric.isFingerprintAvailable,
      status: biometric.status,
      isEnable: biometric.isEnable
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'isAvailable': isAvailable,
      'isFingerprintAvailable': isFingerprintAvailable,
      'status': status.name,
      'isEnable': isEnable,
    };
  }

  Biometric toEntity() {
    return Biometric(
      isAvailable: isAvailable,
      isFingerprintAvailable: isFingerprintAvailable,
      status: status,
      isEnable: isEnable
    );
  }
}