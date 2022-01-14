import 'dart:convert';

import 'package:dio/dio.dart';

class ApiService {
  var baseUrl =
      'http://newsapp-env.eba-rxpntyjw.us-east-2.elasticbeanstalk.com/api/v1';

  var dio = Dio();

  Future<void> register(
      String email, String password, Function success, Function fail) async {
    try {
      final data = {
        'email': email,
        'password': password,
      };

      final formData = FormData.fromMap(data);
      dio.options.headers['content-Type'] = 'application/json';
      var response = await dio.post(baseUrl + '/register', data: formData);

      if (response.data['status'] == 201) {
        success(response.data);
      } else if (response.data['status'] == 409) {
        fail('user already exists!');
      } else {
        fail('something went wrong!');
      }
    } catch (e) {
      print(e);
      fail(e);
    }
  }

  Future<void> login(
      String email, String password, Function success, Function fail) async {
    try {
      final data = {
        'email': email,
        'password': password,
      };

      final formData = FormData.fromMap(data);
      dio.options.headers['content-Type'] = 'application/json';
      var response = await dio.post(baseUrl + '/login', data: formData);

      if (response.data['status'] == 201) {
        success(response.data);
      } else if (response.data['status'] == 401) {
        fail('Invalid Credentials');
      } else {
        fail('something went wrong!');
      }
    } catch (e) {
      print(e);
      fail(e);
    }
  }

  Future<void> prediction(
      String news, int userId, Function success, Function fail) async {
    try {
      final data = {
        'news': news,
        'user_id': userId,
      };

      final formData = FormData.fromMap(data);
      dio.options.headers['content-Type'] = 'application/json';
      var response = await dio.post(baseUrl + '/predict', data: formData);
      if (response.data['status'] == 409) {
        fail('something went wrong!');
      } else if (response.data['status'] == 401) {
        fail('Invalid Credentials');
      } else {
        success(response.data);
      }
    } catch (e) {
      print(e);
      fail(e);
    }
  }
}
