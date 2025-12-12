import 'dart:async';

import 'package:driver_app/features/drive/data/datasources/stop_datasource.dart';
import 'package:driver_app/features/drive/data/repositories/stop_repository_impl.dart';
import 'package:driver_app/features/drive/domain/entities/stop.dart';
import 'package:driver_app/features/drive/domain/repositories/stop_repository.dart';
import 'package:driver_app/shared/providers/shared_preferences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stopDataSourceProvider = Provider<StopDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);

  return StopDataSourceImpl(prefs: prefs);
});

final stopRepositoryProvider = Provider<StopRepository>((ref){
  final datasource = ref.watch(stopDataSourceProvider);

  return StopRepositoryImpl(stopDataSource: datasource);
});

final stopProvider = AsyncNotifierProvider.autoDispose<StopNotifier, Stop>(
  StopNotifier.new,
);

class StopNotifier extends AsyncNotifier<Stop> {
  @override
  FutureOr<Stop> build() {
    throw UnimplementedError();
  }
}