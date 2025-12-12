import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Stop {
  final String id;
  final StopType type;
  String? mediaPath;
  double? latitude;
  double? longitude;
  final String address;
  bool isCompleted;
  DateTime? completedAt;

  Stop({
    String? id,
    required this.type,
    this.mediaPath,
    this.latitude,
    this.longitude,
    required this.address,
    this.isCompleted = false,
    this.completedAt,
  }) : id = id ?? Uuid().v4();

  String get typeLabel => type == StopType.pickup ? 'PICKUP' : 'DROPOFF';
  
  Color get typeColor => type == StopType.pickup ? const Color(0xFF4CAF50) : const Color(0xFFFF5722);

  Stop copyWith({
    String? mediaPath,
    double? latitude,
    double? longitude,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return Stop(
      id: id,
      type: type,
      mediaPath: mediaPath ?? this.mediaPath,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

enum StopType { pickup, dropoff }