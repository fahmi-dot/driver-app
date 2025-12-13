import 'package:driver_app/features/drive/domain/entities/job.dart';
import 'package:driver_app/features/drive/domain/repositories/job_repository.dart';

class AddDummyJobsUseCase {
  final JobRepository _jobRepository;

  AddDummyJobsUseCase(this._jobRepository);

  Future<void> execute(List<Job> jobs) async {
    await _jobRepository.addDummyJobs(jobs);
  }
}