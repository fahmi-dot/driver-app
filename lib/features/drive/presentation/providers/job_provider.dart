import 'dart:async';
import 'dart:developer';

import 'package:driver_app/features/drive/data/datasources/job_datasource.dart';
import 'package:driver_app/features/drive/data/repositories/job_repository_impl.dart';
import 'package:driver_app/features/drive/domain/entities/job.dart';
import 'package:driver_app/features/drive/domain/entities/stop.dart';
import 'package:driver_app/features/drive/domain/repositories/job_repository.dart';
import 'package:driver_app/features/drive/domain/usecases/add_dummy_jobs_usecase.dart';
import 'package:driver_app/features/drive/domain/usecases/get_all_jobs_usecase.dart';
import 'package:driver_app/features/drive/domain/usecases/update_job_usecase.dart';
import 'package:driver_app/shared/providers/shared_preferences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final jobDataSourceProvider = Provider<JobDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);

  return JobDataSourceImpl(prefs: prefs);
});

final jobRepositoryProvider = Provider<JobRepository>((ref) {
  final datasource = ref.watch(jobDataSourceProvider);

  return JobRepositoryImpl(jobDataSource: datasource);
});

final addDummyJobUseCaseProvider = Provider<AddDummyJobsUseCase>((ref) {
  final repository = ref.watch(jobRepositoryProvider);

  return AddDummyJobsUseCase(repository);
});

final getAllJobsUseCaseProvider = Provider<GetAllJobsUseCase>((ref) {
  final repository = ref.watch(jobRepositoryProvider);

  return GetAllJobsUseCase(repository);
});

final updateJobUseCaseProvider = Provider<UpdateJobUseCase>((ref) {
  final repository = ref.watch(jobRepositoryProvider);

  return UpdateJobUseCase(repository);
});

final jobProvider = AsyncNotifierProvider.autoDispose<JobNotifier, List<Job>>(
  JobNotifier.new,
);

class JobNotifier extends AsyncNotifier<List<Job>> {
  @override
  FutureOr<List<Job>> build() {
    _addDummyJobs();
    return _loadJobs();
  }

  Future<void> _addDummyJobs() async {
    try {
      final dummyJobs = [
        Job(
          title: 'Pengiriman Paket Eksklusif',
          customerName: 'PT. Maju Jaya',
          stops: [
            Stop(type: StopType.pickup, address: 'Jl. Sudirman, Jakarta Pusat'),
            Stop(
              type: StopType.dropoff,
              address: 'Jl. Gatot Subroto, Jakarta Selatan',
            ),
          ],
        ),
        Job(
          title: 'Pengiriman Paket Express',
          customerName: 'PT. Maju Terus',
          stops: [
            Stop(type: StopType.pickup, address: 'Jl. Thamrin, Jakarta Pusat'),
            Stop(
              type: StopType.dropoff,
              address: 'Jl. Rasuna Said, Jakarta Selatan',
            ),
          ],
        ),
        Job(
          title: 'Pengiriman Multi-Drop',
          customerName: 'PT. Maju Pantang Mundur',
          stops: [
            Stop(
              type: StopType.pickup,
              address: 'Jl. Gajah Mada, Jakarta Pusat',
            ),
            Stop(
              type: StopType.dropoff,
              address: 'Jl. Kemang Raya, Jakarta Selatan',
            ),
            Stop(
              type: StopType.dropoff,
              address: 'Jl. Ampera Raya, Jakarta Selatan',
            ),
          ],
        ),
      ];

      await ref.read(addDummyJobUseCaseProvider).execute(dummyJobs);
    } catch (e) {
      log('Error adding dummy jobs: $e');
    }
  }

  Future<List<Job>> _loadJobs() async {
    await getAllJobs();

    final jobs = state.value!;
    return jobs;
  }

  Future<void> _updateJob(Job job) async {
    state = AsyncLoading();

    try {
      final updatedJobs = await ref.read(updateJobUseCaseProvider).execute(job);

      state = AsyncData(updatedJobs);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Job? _getJobById(String id) {
    final jobs = state.value!;

    if (jobs.isEmpty) return null;

    return jobs.firstWhere((j) => j.id == id);
  }

  Future<void> getAllJobs() async {
    state = AsyncLoading();

    try {
      final jobs = await ref.read(getAllJobsUseCaseProvider).execute();

      state = AsyncData(jobs);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> startJob(String id) async {
    final job = _getJobById(id);

    if (job == null) return;

    final startedJob = job.copyWith(
      status: JobStatus.ongoing,
      startedAt: DateTime.now(),
    );
    await _updateJob(startedJob);
  }

  Future<void> updateStopJob(String id, String stopId, {
    String? mediaPath,
    double? latitude,
    double? longitude,
    bool? isCompleted,
  }) async {
    final job = _getJobById(id);

    if (job == null) return;
    
    final updatedStops = job.stops.map((s) {
      if (s.id == stopId) {
        return s.copyWith(
          mediaPath: mediaPath,
          latitude: latitude,
          longitude: longitude,
          isCompleted: isCompleted,
        );
      }
      return s;
    }).toList();

    final updatedJob = job.copyWith(
      stops: updatedStops,
    );

    await _updateJob(updatedJob);

    if (job.stops.every((s) => s.isCompleted)) {
      await _completeJob(id);
    }
  }

  Future<void> _completeJob(String id) async {
    final job = _getJobById(id);

    if (job == null) return;

    final completedJob = job.copyWith(
      status: JobStatus.completed,
      completedAt: DateTime.now(),
    );
    await _updateJob(completedJob);
  }
}
