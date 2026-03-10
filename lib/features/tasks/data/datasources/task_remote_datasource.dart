import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks(String userId);
  Future<void> addTask(String userId, TaskModel task);
  Future<void> updateTask(String userId, TaskModel task);
  Future<void> deleteTask(String userId, String taskId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final http.Client client;

  TaskRemoteDataSourceImpl(this.client);

  @override
  Future<List<TaskModel>> getTasks(String userId) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}/tasks/$userId.json'),
      );

      if (response.statusCode == 200) {
        if (response.body == 'null') return [];
        final Map<String, dynamic> data = json.decode(response.body);
        return TaskModel.fromJsonMap(data);
      } else {
        throw ServerException('Failed to load tasks from server');
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> addTask(String userId, TaskModel task) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}/tasks/$userId.json'),
        body: json.encode(task.toJson()),
      );

      if (response.statusCode != 200) {
        throw ServerException('Failed to add task to workspace');
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateTask(String userId, TaskModel task) async {
    try {
      final response = await client.patch(
        Uri.parse('${ApiConstants.baseUrl}/tasks/$userId/${task.id}.json'),
        body: json.encode(task.toJson()),
      );

      if (response.statusCode != 200) {
        throw ServerException('Failed to update task');
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteTask(String userId, String taskId) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConstants.baseUrl}/tasks/$userId/$taskId.json'),
      );

      if (response.statusCode != 200) {
        throw ServerException('Failed to remove task');
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
