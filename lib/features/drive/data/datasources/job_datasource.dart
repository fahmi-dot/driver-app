import 'dart:convert';
import 'dart:developer';

import 'package:driver_app/features/drive/data/models/job_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class JobDataSource {
  Future<void> addDummyJobs(List<JobModel> jobs);
  Future<List<JobModel>> getAllJobs();
  Future<List<JobModel>> updateJob(JobModel job);
}

class JobDataSourceImpl implements JobDataSource {
  static const _key = 'jobs';
  final SharedPreferences prefs;

  JobDataSourceImpl({required this.prefs});

  @override
  Future<void> addDummyJobs(List<JobModel> jobs) async {
    try {
      _saveJobs(jobs);
    } catch (e) {
      log('Error adding dummy jobs: $e');
    }
  }

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
  Future<List<JobModel>> updateJob(JobModel job) async {
    try {
      final jobs = await getAllJobs();
      final index = jobs.indexWhere((j) => j.id == job.id);

      if (index != -1) jobs[index] = job;

      _saveJobs(jobs);
      
      return jobs;
    } catch (e) {
      log('Error updating job: $e');
      return [];
    }
  }

  Future<void> _saveJobs(List<JobModel> jobs) async {
    try {
      final jobsJson = jobs.map((j) => j.toJson()).toList();

      await prefs.setString(_key, jsonEncode(jobsJson));
    } catch (e) {
      log('Error saving jobs: $e');
    }
  }
}