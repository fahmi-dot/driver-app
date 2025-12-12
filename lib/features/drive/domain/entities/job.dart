import 'package:driver_app/features/drive/domain/entities/stop.dart';
import 'package:uuid/uuid.dart';

class Job {
  final String id;
  final String title;
  final String customerName;
  final List<Stop> stops;
  JobStatus status;
  DateTime createdAt;
  DateTime? startedAt;
  DateTime? completedAt;

  Job({
    String? id,
    required this.title,
    required this.customerName,
    required this.stops,
    this.status = JobStatus.pending,
    DateTime? createdAt,
    this.startedAt,
    this.completedAt,
  })  : id = id ?? Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  bool get canStart => status == JobStatus.pending;
  
  bool get isOngoing => status == JobStatus.ongoing;
  
  bool get isCompleted => status == JobStatus.completed;
  
  int get completedStopsCount => stops.where((s) => s.isCompleted).length;
  
  int get totalStops => stops.length;
  
  double get progress => totalStops > 0 ? completedStopsCount / totalStops : 0.0;

  Job copyWith({
    String? title,
    String? customerName,
    List<Stop>? stops,
    JobStatus? status,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return Job(
      id: id,
      title: title ?? this.title,
      customerName: customerName ?? this.customerName,
      stops: stops ?? this.stops,
      status: status ?? this.status,
      createdAt: createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

enum JobStatus { pending, ongoing, completed }