import 'package:devtrack/shared/models/project_request.dart';
import 'package:devtrack/shared/models/project_response.dart';
import 'package:devtrack/shared/repositories/project_repository.dart';
import 'package:flutter/foundation.dart';

class ProjectProvider extends ChangeNotifier{
  final ProjectRepository _projectRepository;
  ProjectProvider(this._projectRepository);

  ProjectResponse? _project;
  List<ProjectResponse> _projects = [];

  bool _isLoading = false;
  String? _error;

  ProjectResponse? get project => _project;
  List<ProjectResponse> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> createProject(ProjectRequest data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _project = await _projectRepository.createProject(data);
      _projects.add(_project!);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProjects() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _projects = await _projectRepository.getProjects();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProject(int projectId, ProjectRequest data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _project = await _projectRepository.updateProject(projectId, data);
      final index = _projects.indexWhere((p) => p.id == projectId);
      if (index != -1) {
        _projects[index] = _project!;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProject(int projectId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _projectRepository.deleteProject(projectId);
      _projects.removeWhere((p) => p.id == projectId);
      if (_project?.id == projectId) {
      _project = null;
    }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProject(int projectId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _project = await _projectRepository.getProject(projectId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


}