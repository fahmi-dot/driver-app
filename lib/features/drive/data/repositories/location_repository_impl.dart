import 'package:driver_app/features/drive/data/datasources/location_datasource.dart';
import 'package:driver_app/features/drive/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource locationDataSource;

  LocationRepositoryImpl({required this.locationDataSource});
}