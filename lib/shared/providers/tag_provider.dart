import 'package:devtrack/shared/models/tag.dart';
import 'package:devtrack/shared/repositories/tag_repository.dart';
import 'package:flutter/foundation.dart';

class TagProvider extends ChangeNotifier {
  final TagRepository _tagRepository;

  TagProvider(this._tagRepository);

  List<Tag> _tags = [];

  bool _isLoading = false;
  String? _error;

  List<Tag> get tags => _tags;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getTags() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tags = await _tagRepository.getTags();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTag(String name) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final tag = await _tagRepository.createTag(name);

      _tags.add(tag);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTag(int tagId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _tagRepository.deleteTag(tagId);

      _tags.removeWhere(
        (tag) => tag.id == tagId,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}