import 'package:devtrack/core/network/api_client.dart';
import 'package:devtrack/shared/models/note_request.dart';
import 'package:devtrack/shared/models/note_response.dart';

class NoteRepository {
  final ApiClient _apiClient;

  NoteRepository(this._apiClient);

  Future<NoteResponse> getNote(int noteId) async {
    final response = await _apiClient.dio.get(
      '/api/notes/$noteId',
    );

    return NoteResponse.fromJson(response.data);
  }

  Future<List<NoteResponse>> getNotes() async {
    final response = await _apiClient.dio.get(
      '/api/notes',
    );

    return (response.data as List)
        .map((note) => NoteResponse.fromJson(note))
        .toList();
  }

  Future<NoteResponse> createNote(NoteRequest request) async {
    final response = await _apiClient.dio.post(
      '/api/notes',
      data: request.toJson(),
    );

    return NoteResponse.fromJson(response.data);
  }

  Future<NoteResponse> updateNote(
    int noteId,
    NoteRequest request,
  ) async {
    final response = await _apiClient.dio.patch(
      '/api/notes/$noteId',
      data: request.toJson(),
    );

    return NoteResponse.fromJson(response.data);
  }

  Future<void> deleteNote(int noteId) async {
    await _apiClient.dio.delete(
      '/api/notes/$noteId',
    );
  }
}