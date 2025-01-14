import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rugram/data/remote_data_sources/profile/profile_data_source.dart';

import 'profile_state.dart';

class ProfilePageCubit extends Cubit<ProfilePageState> {
  final ProfileDataSource profileDataSource;

  final TextEditingController nameController;
  final TextEditingController surnameController;

  ProfilePageCubit(
      {required this.profileDataSource,
      required this.nameController,
      required this.surnameController})
      : super(ProfilePageInitialState(
            profileDataSource: profileDataSource,
            nameControllerValue: nameController,
            surnameControllerValue: surnameController));

  Future<void> initAsync({required String userId}) async {
    emit(state.toLoading());

    await state.initAsync(userId: userId);

    emit(state.toLoaded());
  }

  Future<void> updateAsync(
      {required String userId,
      required String name,
      required String surname}) async {
    emit(state.toLoading());

    await state.updateAsync(userId: userId, name: name, surname: surname);

    emit(state.toLoaded());
  }
}
