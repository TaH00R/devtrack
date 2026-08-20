import 'package:devtrack/shared/models/github_live_data.dart';
import 'package:devtrack/shared/models/github_profile.dart';
import 'package:devtrack/shared/repositories/github_repository.dart';
import 'package:flutter/foundation.dart';

class GithubProvider extends ChangeNotifier {
  final GithubRepository _githubRepository;

  GithubProvider(this._githubRepository);

  List<GithubProfile> _profiles = [];

  GithubLiveData? _liveData;

  bool _isLoading = false;
  bool _isLiveLoading = false;

  String? _error;

  List<GithubProfile> get profiles => _profiles;

  GithubLiveData? get liveData => _liveData;

  bool get isLoading => _isLoading;

  bool get isLiveLoading => _isLiveLoading;

  String? get error => _error;

  Future<void> getProfiles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profiles =
          await _githubRepository.getProfiles();

      if (_profiles.isNotEmpty) {
        await getLiveData(
          _profiles.first.username,
        );
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getLiveData(
    String username,
  ) async {
    _isLiveLoading = true;
    notifyListeners();

    try {
      _liveData =
          await _githubRepository
              .getLiveData(username);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLiveLoading = false;
      notifyListeners();
    }
  }

  Future<void> createProfile(
    String username,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final profile =
          await _githubRepository
              .createProfile(username);

      _profiles.add(profile);

      await getLiveData(username);
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
      final updated =
          await _githubRepository
              .updateProfile(
        profileId,
        profile,
      );

      final index =
          _profiles.indexWhere(
        (item) =>
            item.id == profileId,
      );

      if (index != -1) {
        _profiles[index] = updated;
      }

      await getLiveData(
        updated.username,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProfile(
    int profileId,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _githubRepository
          .deleteProfile(profileId);

      _profiles.removeWhere(
        (profile) =>
            profile.id == profileId,
      );

      _liveData = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}