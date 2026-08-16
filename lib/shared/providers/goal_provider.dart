import 'package:devtrack/shared/models/goal_request.dart';
import 'package:devtrack/shared/models/goal_response.dart';
import 'package:devtrack/shared/repositories/goal_repository.dart';
import 'package:flutter/foundation.dart';

class GoalProvider extends ChangeNotifier {
  final GoalRepository _goalRepository;

  GoalProvider(this._goalRepository);

  GoalResponse? _goal;
  List<GoalResponse> _goals = [];

  bool _isLoading = false;
  String? _error;

  GoalResponse? get goal => _goal;
  List<GoalResponse> get goals => _goals;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getGoal(int goalId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _goal = await _goalRepository.getGoal(goalId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getGoals() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _goals = await _goalRepository.getGoals();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createGoal(GoalRequest data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _goal = await _goalRepository.createGoal(data);
      _goals.add(_goal!);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateGoal(
    int goalId,
    GoalRequest data,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _goal = await _goalRepository.updateGoal(
        goalId,
        data,
      );

      final index = _goals.indexWhere(
        (goal) => goal.id == goalId,
      );

      if (index != -1) {
        _goals[index] = _goal!;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteGoal(int goalId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _goalRepository.deleteGoal(goalId);

      _goals.removeWhere(
        (goal) => goal.id == goalId,
      );

      if (_goal?.id == goalId) {
        _goal = null;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}