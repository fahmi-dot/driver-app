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

final pendingJobsProvider = Provider<List<Job>>((ref) {
  final jobs = ref.watch(jobProvider);

  return jobs.maybeWhen(
    data: (job) => job.where((j) => j.status == JobStatus.pending).toList(),
    orElse: () => [],
  );
}); 

final ongoingJobsProvider = Provider<List<Job>>((ref) {
  final jobs = ref.watch(jobProvider);

  return jobs.maybeWhen(
    data: (job) => job.where((j) => j.status == JobStatus.ongoing).toList(),
    orElse: () => [],
  );
}); 

final completedJobsProvider = Provider<List<Job>>((ref) {
  final jobs = ref.watch(jobProvider);

  return jobs.maybeWhen(
    data: (job) => job.where((j) => j.status == JobStatus.completed).toList(),
    orElse: () => [],
  );
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

  List<Job> _dummyJobs() {
    return [
      {
        'title': 'Pengiriman Paket Eksklusif',
        'customerName': 'PT. Maju Jaya',
        'pickup': 'Jl. Sudirman, Jakarta Pusat',
        'dropoff': 'Jl. Gatot Subroto, Jakarta Selatan',
      },
      {
        'title': 'Pengiriman Paket Express',
        'customerName': 'PT. Maju Terus',
        'pickup': 'Jl. Thamrin, Jakarta Pusat',
        'dropoff': 'Jl. Rasuna Said, Jakarta Selatan',
      },
      {
        'title': 'Pengiriman Multi-Drop',
        'customerName': 'PT. Maju Pantang Mundur',
        'pickup': 'Jl. Gajah Mada, Jakarta Barat',
        'dropoff': 'Jl. Mangga Dua Raya, Jakarta Utara',
      },
      {
        'title': 'Pengiriman Dokumen Penting',
        'customerName': 'PT. Solusi Bisnis',
        'pickup': 'Jl. Jenderal Ahmad Yani, Jakarta Timur',
        'dropoff': 'Jl. Letnan Jenderal S. Parman, Jakarta Barat',
      },
      {
        'title': 'Pengiriman Sparepart Mesin',
        'customerName': 'PT. Teknik Mandiri',
        'pickup': 'Jl. Prof. Dr. Satrio, Jakarta Selatan',
        'dropoff': 'Jl. Tebet Barat Dalam, Jakarta Selatan',
      },
      {
        'title': 'Pengiriman Barang Elektronik',
        'customerName': 'PT. Elektronik Kita',
        'pickup': 'Jl. Asia Afrika, Jakarta Pusat',
        'dropoff': 'Jl. Sudirman, Jakarta Pusat',
      },
      {
        'title': 'Pengiriman Retail Pusat',
        'customerName': 'PT. Retail Nusantara',
        'pickup': 'Jl. K.H. Mas Mansyur, Jakarta Pusat',
        'dropoff': 'Jl. Panglima Polim, Jakarta Selatan',
      },
      {
        'title': 'Pengiriman Barang Gym',
        'customerName': 'PT. Sehat Selalu',
        'pickup': 'Jl. R.E. Martadinata, Jakarta Utara',
        'dropoff': 'Jl. Kebon Sirih, Jakarta Pusat',
      },
      {
        'title': 'Pengiriman Dokumen Kontrak Klien',
        'customerName': 'PT. Bisnis Prima',
        'pickup': 'Jl. Menteng Raya, Jakarta Pusat',
        'dropoff': 'Jl. Senen Raya, Jakarta Pusat',
      },
      {
        'title': 'Pengiriman Paket Khusus',
        'customerName': 'PT. Cepat Sampai',
        'pickup': 'Jl. Pasar Minggu, Jakarta Selatan',
        'dropoff': 'Jl. M.H. Thamrin, Jakarta Pusat',
      },
    ].map((e) => Job(
          title: e['title']!,
          customerName: e['customerName']!,
          stops: [
            Stop(type: StopType.pickup, address: e['pickup']!),
            Stop(type: StopType.dropoff, address: e['dropoff']!),
          ],
        )).toList();
  }

  Future<void> _addDummyJobs() async {
    try {
      final dummyJobs = _dummyJobs();

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

  Future<void> _completeJob(String id) async {
    final job = _getJobById(id);

    if (job == null) return;

    final completedJob = job.copyWith(
      status: JobStatus.completed,
      completedAt: DateTime.now(),
    );
    await _updateJob(completedJob);
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

  Future<Job> getJobById(String id) async {
    return _getJobById(id)!;
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

    if (updatedJob.stops.every((s) => s.isCompleted)) {
      await _completeJob(id);
    }
  }
}