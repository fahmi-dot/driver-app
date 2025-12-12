import 'package:driver_app/features/drive/domain/entities/location.dart';

class LocationModel extends Location {
  LocationModel({
    required super.latitude,
    required super.longitude,
    required super.address,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['latitude'], 
      longitude: json['longitude'], 
      address: json['address'],
    );
  }

  factory LocationModel.fromEntity(Location location) {
    return LocationModel(
      latitude: location.latitude, 
      longitude: location.longitude, 
      address: location.address,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  Location toEntity() {
    return Location(
      latitude: latitude, 
      longitude: longitude,
      address: address,
    );
  }
}