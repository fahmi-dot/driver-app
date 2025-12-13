import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static Future<bool> requestCamera() async {
    final status = await Permission.camera.status;

    if (status.isDenied || status.isRestricted) {
      return (await Permission.camera.request()).isGranted;
    }

    return status.isGranted;
  }

  static Future<bool> requestStorage() async {
    final status = await Permission.storage.status;

    if (status.isDenied || status.isRestricted) {
      return (await Permission.storage.request()).isGranted;
    }

    return status.isGranted;
  }

  static Future<bool> checkLocationServices() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  static Future<bool> requestLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  static Future<void> openSettings() async {
    await openAppSettings();
  }
}