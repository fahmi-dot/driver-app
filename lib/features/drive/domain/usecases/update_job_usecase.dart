import 'package:driver_app/features/drive/domain/entities/job.dart';
import 'package:driver_app/features/drive/domain/repositories/job_repository.dart';

class UpdateJobUseCase {
  final JobRepository _jobRepository;

  UpdateJobUseCase(this._jobRepository);

  Future<List<Job>> execute(Job job) async {
    return await _jobRepository.updateJob(job);
  }
}