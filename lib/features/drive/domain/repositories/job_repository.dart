import 'package:driver_app/features/drive/domain/entities/job.dart';

abstract class JobRepository {
  Future<List<Job>> getAllJobs();
  Future<void> addDummyJobs(List<Job> jobs);
}