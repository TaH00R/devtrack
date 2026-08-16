import 'package:devtrack/shared/models/task_request.dart';
import 'package:devtrack/shared/models/task_response.dart';
import 'package:devtrack/shared/repositories/task_repository.dart';
import 'package:flutter/foundation.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository _taskRepository;
  TaskProvider(this._taskRepository);

  TaskResponse? _task;
  List<TaskResponse> _tasks = [];

  bool _isLoading = false;
  String? _error;

  TaskResponse? get task => _task;
  List<TaskResponse> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getTask(int taskId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _task = await _taskRepository.getTask(taskId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _taskRepository.getTasks();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTask(TaskRequest request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _task = await _taskRepository.createTask(request);
      _tasks.add(_task!);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTask(int taskId, TaskRequest request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _task = await _taskRepository.updateTask(taskId, request);
      final index = _tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        _tasks[index] = _task!;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTask(int taskId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _taskRepository.deleteTask(taskId);
      _tasks.removeWhere((t) => t.id == taskId);
      if (_task?.id == taskId) {
        _task = null;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}