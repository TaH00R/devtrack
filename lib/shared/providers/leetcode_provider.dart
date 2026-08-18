import 'package:devtrack/shared/models/leetcode_profile.dart';
import 'package:devtrack/shared/repositories/leetcode_repository.dart';
import 'package:flutter/foundation.dart';

class LeetcodeProvider extends ChangeNotifier {
  final LeetcodeRepository _leetcodeRepository;

  LeetcodeProvider(this._leetcodeRepository);

  List<LeetcodeProfile> _profiles = [];

  bool _isLoading = false;
  String? _error;

  List<LeetcodeProfile> get profiles => _profiles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getProfiles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profiles = await _leetcodeRepository.getProfiles();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createProfile(
    LeetcodeProfile profile,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final createdProfile =
          await _leetcodeRepository.createProfile(profile);

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
    LeetcodeProfile profile,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedProfile =
          await _leetcodeRepository.updateProfile(
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
      await _leetcodeRepository.deleteProfile(profileId);

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