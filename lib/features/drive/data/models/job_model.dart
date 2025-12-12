import 'package:driver_app/features/drive/data/models/stop_model.dart';
import 'package:driver_app/features/drive/domain/entities/job.dart';

class JobModel extends Job {
  JobModel({
    required super.id, 
    required super.title, 
    required super.customerName, 
    required super.stops,
    required super.status,
    required super.createdAt,
    required super.startedAt,
    required super.completedAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'],
      title: json['title'],
      customerName: json['customerName'],
      stops: (json['stops'] as List).map((s) => StopModel.fromJson(s)).toList(),
      status: JobStatus.values.byName(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      startedAt: json['startedAt'] != null 
          ? DateTime.parse(json['startedAt']) 
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }

  factory JobModel.fromEntity(Job job) {
    return JobModel(
      id: job.id, 
      title: job.title,
      customerName: job.customerName,
      stops: job.stops,
      status: job.status,
      createdAt: job.createdAt,
      startedAt: job.startedAt,
      completedAt: job.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'customerName': customerName,
      'stops': stops.map((s) => StopModel.fromEntity(s).toJson()).toList(),
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  Job toEntity() {
    return Job(
      id: id,
      title: title, 
      customerName: customerName, 
      stops: stops,
      status: status,
      createdAt: createdAt,
      startedAt: startedAt,
      completedAt: completedAt,
    );
  }
}