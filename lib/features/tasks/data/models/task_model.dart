import '../entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.title,
    super.description,
    super.isCompleted,
    required super.createdAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json, String id) {
    return TaskModel(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static List<TaskModel> fromJsonMap(Map<String, dynamic> map) {
    final List<TaskModel> tasks = [];
    map.forEach((key, value) {
      tasks.add(TaskModel.fromJson(Map<String, dynamic>.from(value), key));
    });
    return tasks;
  }
}
