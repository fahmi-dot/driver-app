class Biometric {
  final bool isAvailable;
  final bool isFingerprintAvailable;
  final BiometricStatus status;
  final bool isEnable;

  Biometric({
    required this.isAvailable,
    required this.isFingerprintAvailable,
    required this.status,
    required this.isEnable,
  });

  String get availableTypeString {
    if (isFingerprintAvailable) return 'Fingerprint';
    return 'None';
  }

  Biometric copyWith({
    bool? isEnable,
  }) {
    return Biometric(
      isAvailable: isAvailable,
      isFingerprintAvailable: isFingerprintAvailable,
      status: status,
      isEnable: isEnable ?? this.isEnable,
    );
  }
}

enum BiometricStatus { available, notAvailable, notEnrolled, notChecked, unsupported }