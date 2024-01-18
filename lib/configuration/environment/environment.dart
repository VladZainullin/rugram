import 'package:dio/dio.dart';

class Environment {
  static final BaseOptions baseDioOptions = BaseOptions(
    baseUrl: 'https://dummyapi.io/data/v1/',
    headers: {
      'app-id': '6578bf8cf7b31e5d8be75ba3',
    },
  );
}
