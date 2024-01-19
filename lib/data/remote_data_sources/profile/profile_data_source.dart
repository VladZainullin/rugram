import 'package:dio/dio.dart';
import '../../../domain/models/user_preview.dart';
import '../../../data/remote_data_sources/models/user_preview.dart'
    as source_user_preview;

class ProfileDataSource {
  final Dio dio;

  ProfileDataSource(this.dio);

  Future<UserPreview> getProfileAsync({required String userId}) async {
    final result = await dio.get('/user/$userId');
    final model = source_user_preview.UserPreview.fromJson(result.data).toEntity();

    return model;
  }

  Future<UserPreview> updateProfileAsync(
      {required String profileId, required String name, required, required String surname}) async {
    final result = await dio.put('/user/$profileId', data: {
      'firstName': name,
      'lastName': surname
    });

    var userPreview =
        source_user_preview.UserPreview.fromJson(result.data).toEntity();
    return userPreview;
  }
}
