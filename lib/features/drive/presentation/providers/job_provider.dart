import 'dart:async';
import 'dart:developer';

import 'package:driver_app/features/drive/data/datasources/job_datasource.dart';
import 'package:driver_app/features/drive/data/repositories/job_repository_impl.dart';
import 'package:driver_app/features/drive/domain/entities/job.dart';
import 'package:driver_app/features/drive/domain/entities/stop.dart';
import 'package:driver_app/features/drive/domain/repositories/job_repository.dart';
import 'package:driver_app/features/drive/domain/usecases/add_dummy_jobs_usecase.dart';
import 'package:driver_app/features/drive/domain/usecases/get_all_jobs_usecase.dart';
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

final getAllJobsUseCaseProvider = Provider<GetAllJobsUseCase>((ref) {
  final repository = ref.watch(jobRepositoryProvider);

  return GetAllJobsUseCase(repository);
});

final addDummyJobUseCaseProvider = Provider<AddDummyJobsUseCase>((ref) {
  final repository = ref.watch(jobRepositoryProvider);

  return AddDummyJobsUseCase(repository);
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
            Stop(
              type: StopType.pickup,
              address: 'Jl. Sudirman, Jakarta Pusat',
            ),
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
            Stop(
              type: StopType.pickup,
              address: 'Jl. Thamrin, Jakarta Pusat',
            ),
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

    return state.maybeWhen(
      data: (jobs) => jobs,
      orElse: () => [],
    );
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
}