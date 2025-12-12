import 'dart:async';

import 'package:driver_app/features/drive/data/datasources/job_datasource.dart';
import 'package:driver_app/features/drive/data/repositories/job_repository_impl.dart';
import 'package:driver_app/features/drive/domain/entities/job.dart';
import 'package:driver_app/features/drive/domain/repositories/job_repository.dart';
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

final jobProvider = AsyncNotifierProvider.autoDispose<JobNotifier, List<Job>>(
  JobNotifier.new,
);

class JobNotifier extends AsyncNotifier<List<Job>> {
  @override
  FutureOr<List<Job>> build() {
    throw UnimplementedError();
  }
}