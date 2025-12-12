import 'package:driver_app/features/drive/data/datasources/stop_datasource.dart';
import 'package:driver_app/features/drive/domain/repositories/stop_repository.dart';

class StopRepositoryImpl implements StopRepository {
  final StopDataSource stopDataSource;

  StopRepositoryImpl({required this.stopDataSource});
}