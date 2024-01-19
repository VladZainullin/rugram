import 'package:flutter/material.dart';

import '../../data/remote_data_sources/profile/profile_data_source.dart';
import '../../domain/models/user_preview.dart';

sealed class ProfilePageState {
  String fullName();

  TextEditingController nameController();

  TextEditingController surnameController();

  Future<void> initAsync({required String userId});

  Future<void> updateAsync({
    required String userId,
    required String name,
    required String surname});

  ProfilePageState toLoading();

  ProfilePageState toLoaded();
}

class ProfilePageInitialState extends ProfilePageState {
  final ProfileDataSource profileDataSource;

  ProfilePageInitialState({required this.profileDataSource});

  @override
  ProfilePageState toLoaded() {
    // TODO: implement ToLoaded
    throw UnimplementedError();
  }

  @override
  ProfilePageState toLoading() {
    return ProfilePageLoadingState(profileDataSource: profileDataSource);
  }

  @override
  String fullName() {
    return "...";
  }

  @override
  Future<void> initAsync({required String userId}) {
    // TODO: implement initAsync
    throw UnimplementedError();
  }

  @override
  TextEditingController nameController() {
    return TextEditingController(text: "...");
  }

  @override
  TextEditingController surnameController() {
    return TextEditingController(text: "...");
  }

  @override
  Future<void> updateAsync({required String userId, required String name, required String surname}) {
    // TODO: implement updateAsync
    throw UnimplementedError();
  }
}

class ProfilePageLoadingState extends ProfilePageState {
  final ProfileDataSource profileDataSource;
  late UserPreview? profile = null;

  ProfilePageLoadingState({UserPreview? profile, required this.profileDataSource}){
    profile = profile;
  }

  @override
  ProfilePageState toLoaded() {
    return ProfilePageLoadedState(profile: profile!, profileDataSource: profileDataSource);
  }

  @override
  ProfilePageState toLoading() {
    return this;
  }

  @override
  String fullName() {
    return profile?.fullName ?? "";
  }

  @override
  TextEditingController nameController() {
    return TextEditingController(text: profile?.firstName ?? "");
  }

  @override
  TextEditingController surnameController() {
    return TextEditingController(text: profile?.lastName ?? "");
  }

  @override
  Future<void> initAsync({required String userId}) async {
    profile = await profileDataSource.getProfileAsync(userId: userId);
  }

  @override
  Future<void> updateAsync({required String userId, required String name, required String surname}) async {
    profile = await profileDataSource.updateProfileAsync(profileId: userId, name: name, surname: surname);
  }
}

class ProfilePageLoadedState extends ProfilePageState {

  final UserPreview profile;
  final ProfileDataSource profileDataSource;

  ProfilePageLoadedState({required this.profile, required this.profileDataSource});

  @override
  ProfilePageState toLoaded() {
    return this;
  }

  @override
  ProfilePageState toLoading() {
    return ProfilePageLoadingState(profile: profile, profileDataSource: profileDataSource);
  }

  @override
  String fullName() {
    return profile.fullName;
  }

  @override
  Future<void> initAsync({required String userId}) {
    // TODO: implement initAsync
    throw UnimplementedError();
  }

  @override
  TextEditingController nameController() {
    return TextEditingController(text: profile.firstName);
  }

  @override
  TextEditingController surnameController() {
    return TextEditingController(text: profile.lastName);
  }

  @override
  Future<void> updateAsync({required String userId, required String name, required String surname}) async {
    // TODO: implement initAsync
    throw UnimplementedError();
  }
}