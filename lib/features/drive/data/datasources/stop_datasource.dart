import 'package:shared_preferences/shared_preferences.dart';

abstract class StopDataSource {

}

class StopDataSourceImpl implements StopDataSource {
  final SharedPreferences prefs;

  StopDataSourceImpl({required this.prefs});
}