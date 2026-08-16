import 'package:devtrack/shared/models/note_response.dart';
import 'package:devtrack/shared/repositories/note_repository.dart';
import 'package:flutter/foundation.dart';

class NoteProvider extends ChangeNotifier{
  final NoteRepository _noteRepository;
  NoteProvider(this._noteRepository);

  NoteResponse? _note;
  bool _isLoading = false;
  String? _error;

  NoteResponse? get note => _note;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getNote(int noteId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _note = await _noteRepository.getNote(noteId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createNote(
    Map<String, dynamic> data,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _note = await _noteRepository.createNote(data);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateNote(
    int noteId,
    Map<String, dynamic> data,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _note = await _noteRepository.updateNote(noteId, data);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteNote(int noteId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _noteRepository.deleteNote(noteId);
      _note = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}