import 'dart:async';

import 'package:driver_app/features/drive/data/datasources/location_datasource.dart';
import 'package:driver_app/features/drive/data/repositories/location_repository_impl.dart';
import 'package:driver_app/features/drive/domain/entities/location.dart';
import 'package:driver_app/features/drive/domain/repositories/location_repository.dart';
import 'package:driver_app/shared/providers/shared_preferences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final locationDataSourceProvider = Provider<LocationDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);

  return LocationDataSourceImpl(prefs: prefs);
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  final datasource = ref.watch(locationDataSourceProvider);

  return LocationRepositoryImpl(locationDataSource: datasource);
});

final locationProvider = AsyncNotifierProvider.autoDispose<LocationNotifier, Location>(
  LocationNotifier.new,
);

class LocationNotifier extends AsyncNotifier<Location> {
  @override
  FutureOr<Location> build() {
    throw UnimplementedError();
  }
}