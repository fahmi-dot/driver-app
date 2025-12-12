import 'package:shared_preferences/shared_preferences.dart';

abstract class JobDataSource {

}

class JobDataSourceImpl implements JobDataSource {
  final SharedPreferences prefs;

  JobDataSourceImpl({required this.prefs});
}