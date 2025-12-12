import 'package:driver_app/features/drive/domain/entities/stop.dart';

class StopModel extends Stop {
  StopModel({
    required super.id,
    required super.type,
    required super.mediaPath,
    required super.latitude,
    required super.longitude,
    required super.address,
    required super.isCompleted,
    required super.completedAt,
  });

  factory StopModel.fromJson(Map<String, dynamic> json) {
    return StopModel(
      id: json['id'],
      type: StopType.values.byName(json['type']),
      mediaPath: json['mediaPath'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }

  factory StopModel.fromEntity(Stop stop) {
    return StopModel(
      id: stop.id,
      type: stop.type,
      mediaPath: stop.mediaPath,
      latitude: stop.latitude,
      longitude: stop.longitude,
      address: stop.address,
      isCompleted: stop.isCompleted,
      completedAt: stop.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'mediaPath': mediaPath,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  Stop toEntity() {
    return Stop(
      id: id,
      type: type,
      mediaPath: mediaPath,
      latitude: latitude,
      longitude: longitude,
      address: address,
      isCompleted: isCompleted,
      completedAt: completedAt,
    );
  }
}