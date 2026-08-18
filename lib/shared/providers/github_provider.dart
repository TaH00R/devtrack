import 'package:devtrack/shared/models/github_profile.dart';
import 'package:devtrack/shared/repositories/github_repository.dart';
import 'package:flutter/foundation.dart';

class GithubProvider extends ChangeNotifier {
  final GithubRepository _githubRepository;

  GithubProvider(this._githubRepository);

  List<GithubProfile> _profiles = [];

  bool _isLoading = false;
  String? _error;

  List<GithubProfile> get profiles => _profiles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getProfiles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profiles = await _githubRepository.getProfiles();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createProfile(
    GithubProfile profile,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final createdProfile =
          await _githubRepository.createProfile(profile);

      _profiles.add(createdProfile);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(
    int profileId,
    GithubProfile profile,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedProfile =
          await _githubRepository.updateProfile(
        profileId,
        profile,
      );

      final index = _profiles.indexWhere(
        (profile) => profile.id == profileId,
      );

      if (index != -1) {
        _profiles[index] = updatedProfile;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProfile(int profileId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _githubRepository.deleteProfile(profileId);

      _profiles.removeWhere(
        (profile) => profile.id == profileId,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}