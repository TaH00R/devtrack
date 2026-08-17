import 'package:devtrack/core/network/api_client.dart';
import 'package:devtrack/shared/models/tag.dart';

class TagRepository {
  final ApiClient _apiClient;

  TagRepository(this._apiClient);

  Future<List<Tag>> getTags() async {
    final response = await _apiClient.dio.get(
      '/api/tags',
    );

    return (response.data as List)
        .map(
          (tag) => Tag.fromJson(tag),
        )
        .toList();
  }

  Future<Tag> createTag(String name) async {
    final response = await _apiClient.dio.post(
      '/api/tags',
      data: {
        'name': name,
      },
    );

    return Tag.fromJson(response.data);
  }

  Future<void> deleteTag(int tagId) async {
    await _apiClient.dio.delete(
      '/api/tags/$tagId',
    );
  }
}