import 'package:dio/dio.dart';

import '../../../domain/models/list_model.dart';
import '../../../domain/models/user_preview.dart';
import '../../../data/remote_data_sources/models/list_model.dart'
    as source_source_list_model;
import '../../../data/remote_data_sources/models/user_preview.dart'
    as source_user_preview;

class ProfileDataSource {
  final Dio dio;

  ProfileDataSource(this.dio);

  Future<ListModel<UserPreview>> getProfiles() async {
    final result = await dio.get('/user');
    final model = source_source_list_model.ListModel.fromJson(result.data)
        .toEntity<UserPreview>(
      (a) => source_user_preview.UserPreview.fromJson(a).toEntity(),
    ) as ListModel<UserPreview>;

    return model;
  }

  Future<UserPreview> updateProfile(
      {required String profileId, required String name, required, required String surname}) async {
    final result = await dio.put('/user/$profileId', data: {
      'firstName': name,
      'lastName': surname
    });

    var userPreview =
        source_user_preview.UserPreview.fromJson(result.data).toEntity();
    return userPreview;
  }

  Future<UserPreview> updateProfileUserPhoto(
      {required String profileId, required String userPicture}) async {
    final result =
        await dio.put('/user/$profileId', data: {'picture': userPicture});

    var userPreview =
        source_user_preview.UserPreview.fromJson(result.data).toEntity();
    return userPreview;
  }
}
