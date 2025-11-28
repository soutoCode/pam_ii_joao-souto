import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ristretto/core/enums/theme.dart';

import 'package:ristretto/core/models/iuser.dart';
import 'package:ristretto/core/services/api_client.dart';
import 'package:ristretto/core/services/auth.dart';

// Centralize API calls regarding User
class UserService{
  // Singleton Pattern
  static final UserService instance=UserService._constructor();
  UserService._constructor();

  final _storage=FlutterSecureStorage();

  // Login
  Future<void> login({
    required String email,
    required String password
  })async{
    try{
      final response=await ApiClient.instance.dio.post(
        '/auth/login',
        data:{
          'email':email,
          'password':password,
        },
      );

      final accessToken=response.data['accessToken'];

      await AuthService.instance.saveAccessToken(accessToken:accessToken);
    }catch(error){
      rethrow;
    }
  }

  // Register Step 1
  Future<Map<String,String>> registerStep1({
    required String email,
    required String password,
    required String confirmPassword,
  })async{
    try{
      debugPrint('INTERNAL GUYS 1');
      final response=await ApiClient.instance.dio.post(
        '/register/step-1',
        data:{
          'email':email,
          'password':password,
          'confirmPassword':confirmPassword,
        },
      );
      debugPrint('INTERNAL GUYS 2');

      final registrationToken=(Map<String,dynamic>.from(response.data!))['registrationToken'];

      await _storage.write(key:'registration-token',value:registrationToken);

      return{};
    }on DioException catch(error){
      return Map<String,String>.from(error.response!.data);
    }
  }

  // Register Step 2
  Future<Map<String,String>> registerStep2({
    required String name,
  })async{
    try{
      final registrationToken=await _storage.read(key:'registration-token');

      final response=await ApiClient.instance.dio.post(
        '/register/step-2',
        data:{
          'name':name,
        },
        options:Options(
          headers:{
            'registration-token':registrationToken,
          },
        ),
      );

      return{};
    }on DioException catch(error){
      return Map<String,String>.from(error.response!.data);
    }
  }

  // Get Authenticated User Data
  Future<IUser> getMe()async{
    try{
      final String? accessToken=await AuthService.instance.getAccessToken();

      if(accessToken==null)throw Exception('no access token found');

      final response=await ApiClient.instance.dio.get(
        '/auth/me',
        options:Options(
          headers:{
            'Authorization':'Bearer $accessToken',
          },
        ),
      );

      final data=response.data;

      final user=IUser(
        id:data['id'].toString(),
        name:data['name'],
        email:data['email'],
        isDarkModePreferred:data['is_dark_mode_preferred'],
      );

      return user;
    }on DioException catch(err){
      throw Exception('Failed to fetch user: ${err.message}');
    }
  }

  Future<void> toggleTheme(TheTheme theme)async{
    try{
      final String? accessToken=await AuthService.instance.getAccessToken();

      if(accessToken==null)throw Exception('no access token found');

      await ApiClient.instance.dio.patch(
        '/auth/me/theme',
        data:{
          'is_dark_mode_preferred':theme==TheTheme.dark,
        },
        options:Options(
          headers:{
            'Authorization':'Bearer $accessToken',
          },
        ),
      );
    }on DioException catch(err){
      throw Exception('Failed to set theme: ${err.message}');
    }
  }
}
