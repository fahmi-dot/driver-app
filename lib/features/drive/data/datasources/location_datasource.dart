import 'package:shared_preferences/shared_preferences.dart';

abstract class LocationDataSource {

}

class LocationDataSourceImpl implements LocationDataSource {
  final SharedPreferences prefs;

  LocationDataSourceImpl({required this.prefs});
}