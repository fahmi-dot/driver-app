import 'dart:convert';
import 'dart:developer';

import 'package:driver_app/features/drive/data/models/job_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class JobDataSource {
  Future<List<JobModel>> getAllJobs();
  Future<void> addDummyJobs(List<JobModel> jobs);
}

class JobDataSourceImpl implements JobDataSource {
  static const _key = 'jobs';
  final SharedPreferences prefs;

  JobDataSourceImpl({required this.prefs});

  @override
  Future<List<JobModel>> getAllJobs() async {
    try {
      final jobsEncode = prefs.getString(_key);

      if (jobsEncode == null) return [];

      final List<dynamic> jobs = jsonDecode(jobsEncode);
      
      return jobs.map((j) => JobModel.fromJson(j)).toList();
    } catch (e) {
      log('Error getting all jobs: $e');
      return [];
    }
  }

  @override
  Future<void> addDummyJobs(List<JobModel> jobs) async {
    try {
      final jobsJson = jobs.map((j) => j.toJson()).toList();

      _saveJobs(jobsJson);
    } catch (e) {
      log('Error adding dummy jobs: $e');
    }
  }

  Future<void> _saveJobs(List<Map<String, dynamic>> jobs) async {
    try {
      await prefs.setString(_key, jsonEncode(jobs));
    } catch (e) {
      log('Error saving jobs: $e');
    }
  }
}