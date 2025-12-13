import 'package:driver_app/features/drive/data/datasources/job_datasource.dart';
import 'package:driver_app/features/drive/data/models/job_model.dart';
import 'package:driver_app/features/drive/domain/entities/job.dart';
import 'package:driver_app/features/drive/domain/repositories/job_repository.dart';

class JobRepositoryImpl implements JobRepository {
  final JobDataSource jobDataSource;

  JobRepositoryImpl({required this.jobDataSource});

  @override
  Future<List<Job>> getAllJobs() async {
    final jobsModel = await jobDataSource.getAllJobs();

    return jobsModel.map((j) => j.toEntity()).toList();
  }

  @override
  Future<void> addDummyJobs(List<Job> jobs) async {
    final jobsModel = jobs.map((j) => JobModel.fromEntity(j)).toList(); 

    await jobDataSource.addDummyJobs(jobsModel);
  }

  @override
  Future<List<Job>> updateJob(Job job) async {
    final jobModel = JobModel.fromEntity(job);
    final jobsModel = await jobDataSource.updateJob(jobModel);

    return jobsModel.map((j) => j.toEntity()).toList();
  }
}