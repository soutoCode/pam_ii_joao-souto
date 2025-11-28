import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

import 'package:ristretto/core/models/icategory.dart';
import 'package:ristretto/core/services/auth.dart';
import 'package:ristretto/core/services/api_client.dart';

// Centralize API calls regarding Category
class CategoryService{
  // Singleton pattern
  static final CategoryService instance=CategoryService._constructor();
  CategoryService._constructor();

  final _storage=FlutterSecureStorage();

  // Create Category for Authenticated User
  Future<ICategory> create({
    required name,
    required Color color,
    String? icon,
  })async{
    final accessToken=await _storage.read(key:'access-token');

    // CHECK WHETHER THE TOKEN HAS EXPIRED AND REQUIRE, IF NECESSARY, THE USER TO LOG IN AGAIN
    if(accessToken==null)throw Exception('No access token');

    String hexColor='#${color.value.toRadixString(16).substring(2).toUpperCase()}';

    try{
      final response=await ApiClient.instance.dio.post(
        '/auth/me/categories',
        data:{
          'name':name,
          'color':hexColor,
          'icon':icon,
          'type':'normal',
        },
        options:Options(
          headers:{
            'Authorization':'Bearer $accessToken',
          },
        ),
      );

      final ICategory newCategory=ICategory.fromMap(response.data);

      return newCategory;
    }on DioException catch(err){
      rethrow;
    }
  }

  // Get Categories of Authenticated User
  Future<List<ICategory>> getCategories()async{
    final String? accessToken=await AuthService.instance.getAccessToken();

    // CHECK WHETHER THE TOKEN HAS EXPIRED AND REQUIRE, IF NECESSARY, THE USER TO LOG IN AGAIN
    if(accessToken==null)throw Exception('NO TOKEN');

    try{
      final response=await ApiClient.instance.dio.get(
        '/auth/me/categories',
        options:Options(
          headers:{
            'Authorization':'Bearer $accessToken',
          },
        ),
      );

      final List<ICategory> categories=(response.data as List)
        .map((map)=>ICategory.fromMap(map))
        .toList();

      return categories;
    }catch(error){
      rethrow;
    }
  }

  Future<ICategory> getCategoryById(String id)async{
    final String? accessToken=await AuthService.instance.getAccessToken();

    if(accessToken==null)throw Exception('No access token');

    final response=await ApiClient.instance.dio.get(
      '/auth/me/categories/$id',
      options:Options(
        headers:{
          'Authorization':'Bearer $accessToken',
        },
      ),
    );

    ICategory category=ICategory.fromMap(response.data);

    return category;
  }

  Future<void> deleteCategoryById(String id)async{
    final String? accessToken=await AuthService.instance.getAccessToken();

    if(accessToken==null)throw Exception('No access token');

    await ApiClient.instance.dio.delete(
      '/auth/me/categories/$id',
      options:Options(
        headers:{
          'Authorization':'Bearer $accessToken',
        },
      ),
    );
  }

  Future<void> updateCategoryById(String id,String name,Color color)async{
    final accessToken=await _storage.read(key:'access-token');

    // CHECK WHETHER THE TOKEN HAS EXPIRED AND REQUIRE, IF NECESSARY, THE USER TO LOG IN AGAIN
    if(accessToken==null)throw Exception('No access token');

    String hexColor='#${color.value.toRadixString(16).substring(2).toUpperCase()}';

    try{
      await ApiClient.instance.dio.patch(
        '/auth/me/categories/$id',
        data:{
          'name':name,
          'color':hexColor,
        },
        options:Options(
          headers:{
            'Authorization':'Bearer $accessToken',
          },
        ),
      );
    }catch(err){
      rethrow;
    }
  }
}
