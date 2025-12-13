import 'package:driver_app/features/drive/domain/entities/job.dart';

abstract class JobRepository {
  Future<void> addDummyJobs(List<Job> jobs);
  Future<List<Job>> getAllJobs();
  Future<List<Job>> updateJob(Job job);
}