import 'package:flutter/material.dart';
import '../../data/remote_data_sources/profile/profile_data_source.dart';

sealed class ProfilePageState {
  String fullName();

  String picture();

  TextEditingController nameController();

  TextEditingController surnameController();

  Future<void> initAsync({required String userId});

  Future<void> updateAsync(
      {required String userId, required String name, required String surname});

  ProfilePageState toLoading();

  ProfilePageState toLoaded();
}

class ProfilePageInitialState extends ProfilePageState {
  final ProfileDataSource profileDataSource;

  final TextEditingController nameControllerValue;
  final TextEditingController surnameControllerValue;

  ProfilePageInitialState(
      {required this.profileDataSource,
      required this.nameControllerValue,
      required this.surnameControllerValue});

  @override
  ProfilePageState toLoaded() {
    // TODO: implement ToLoaded
    throw UnimplementedError();
  }

  @override
  ProfilePageState toLoading() {
    return ProfilePageLoadingState(
        profileDataSource: profileDataSource,
        nameControllerValue: nameControllerValue,
        surnameControllerValue: surnameControllerValue);
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
    return nameControllerValue;
  }

  @override
  TextEditingController surnameController() {
    return surnameControllerValue;
  }

  @override
  Future<void> updateAsync(
      {required String userId, required String name, required String surname}) {
    // TODO: implement updateAsync
    throw UnimplementedError();
  }

  @override
  String picture() {
    return "...";
  }
}

class ProfilePageLoadingState extends ProfilePageState {
  final ProfileDataSource profileDataSource;

  final TextEditingController nameControllerValue;
  final TextEditingController surnameControllerValue;

  late String? fullNameValue;
  late String? pictureValue;

  ProfilePageLoadingState(
      {this.fullNameValue,
      this.pictureValue,
      required this.nameControllerValue,
      required this.surnameControllerValue,
      required this.profileDataSource});

  @override
  ProfilePageState toLoaded() {
    return ProfilePageLoadedState(
        profileDataSource: profileDataSource,
        pictureValue: pictureValue!,
        fullNameValue: fullNameValue!,
        nameControllerValue: nameControllerValue,
        surnameControllerValue: surnameControllerValue);
  }

  @override
  ProfilePageState toLoading() {
    return this;
  }

  @override
  String fullName() {
    return fullNameValue ?? "...";
  }

  @override
  TextEditingController nameController() {
    return nameControllerValue;
  }

  @override
  TextEditingController surnameController() {
    return nameControllerValue;
  }

  @override
  Future<void> initAsync({required String userId}) async {
    final profile = await profileDataSource.getProfileAsync(userId: userId);

    fullNameValue = profile.fullName;
    pictureValue = profile.picture;
    nameControllerValue.text = profile.firstName;
    surnameControllerValue.text = profile.lastName;
  }

  @override
  Future<void> updateAsync(
      {required String userId,
      required String name,
      required String surname}) async {
    final profile = await profileDataSource.updateProfileAsync(
        profileId: userId, name: name, surname: surname);

    fullNameValue = profile.fullName;
    pictureValue = profile.picture;
    nameControllerValue.text = profile.firstName;
    surnameControllerValue.text = profile.lastName;
  }

  @override
  String picture() {
    return pictureValue ?? "";
  }
}

class ProfilePageLoadedState extends ProfilePageState {
  final String fullNameValue;
  final String pictureValue;

  final TextEditingController nameControllerValue;
  final TextEditingController surnameControllerValue;

  final ProfileDataSource profileDataSource;

  ProfilePageLoadedState(
      {required this.profileDataSource,
      required this.fullNameValue,
      required this.pictureValue,
      required this.nameControllerValue,
      required this.surnameControllerValue});

  @override
  ProfilePageState toLoaded() {
    return this;
  }

  @override
  ProfilePageState toLoading() {
    return ProfilePageLoadingState(
      profileDataSource: profileDataSource,
      nameControllerValue: nameControllerValue,
      surnameControllerValue: surnameControllerValue,
    );
  }

  @override
  String fullName() {
    return fullNameValue;
  }

  @override
  Future<void> initAsync({required String userId}) {
    // TODO: implement initAsync
    throw UnimplementedError();
  }

  @override
  TextEditingController nameController() {
    return nameControllerValue;
  }

  @override
  TextEditingController surnameController() {
    return surnameControllerValue;
  }

  @override
  Future<void> updateAsync(
      {required String userId,
      required String name,
      required String surname}) async {
    // TODO: implement initAsync
    throw UnimplementedError();
  }

  @override
  String picture() {
    return pictureValue;
  }
}
