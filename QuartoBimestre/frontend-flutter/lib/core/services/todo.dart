import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

import 'package:ristretto/core/enums/todo_filter.dart';
import 'package:ristretto/core/models/itodo.dart';
import 'package:ristretto/core/services/api_client.dart';
import 'package:ristretto/core/services/auth.dart';

class TodoService{
  // Singleton pattern
  static final TodoService instance=TodoService._constructor();
  TodoService._constructor();

  Future<List<ITodo>> getTodos({required TodoFilter filter})async{
    final String? accessToken=await AuthService.instance.getAccessToken();

    if(accessToken==null)throw Exception('No access token');

    Map<String,String> filterMap={};

    switch(filter){
      case TodoFilter.all:
        break;
      case TodoFilter.today:
        filterMap['filter']='today';
        break;
      case TodoFilter.thisWeek:
        filterMap['filter']='thisWeek';
        break;
      case TodoFilter.overdue:
        filterMap['filter']='overdue';
        break;
    }

    final response=await ApiClient.instance.dio.get(
      '/auth/me/todos',
      queryParameters:filterMap,
      options:Options(
        headers:{
          'Authorization':'Bearer $accessToken',
        },
      ),
    );

    final List<ITodo> todos=(response.data as List)
      .map((map)=>ITodo.fromMap(map))
      .toList();

    return todos;
  }

  Future<List<ITodo>> getTodosByCategoryId(String id)async{
    final String? accessToken=await AuthService.instance.getAccessToken();

    if(accessToken==null)throw Exception('No access token');

    final response=await ApiClient.instance.dio.get(
      '/auth/me/categories/$id/todos',
      options:Options(
        headers:{
          'Authorization':'Bearer $accessToken',
        },
      ),
    );

    // (response.data as List).forEach((map){debugPrint(map.toString());});
    final List<ITodo> todos=(response.data as List)
      .map((map)=>ITodo.fromMap(map))
      .toList();

    return todos;
  }

  Future<ITodo> create(String title,DateTime? duedate,String categoryId)async{
    final String? accessToken=await AuthService.instance.getAccessToken();

    if(accessToken==null)throw Exception('No access token');

    final response=await ApiClient.instance.dio.post(
      '/auth/me/categories/$categoryId/todos',
      data:{
        'title':title,
        'due_date':duedate!=null?duedate.toIso8601String().split('T')[0]:null,
      },
      options:Options(
        headers:{
          'Authorization':'Bearer $accessToken',
        },
      ),
    );

    final ITodo newTodo=ITodo.fromMap(response.data);

    return newTodo;
  }

  Future<void> deleteTodosById(List<String> ids)async{
    final String? accessToken=await AuthService.instance.getAccessToken();

    if(accessToken==null)throw Exception('No access token');

    await ApiClient.instance.dio.delete(
      '/auth/me/todos',
      data:{
        'todosId':ids,
      },
      options:Options(
        headers:{
          'Authorization':'Bearer $accessToken',
        },
      ),
    );
  }

  Future<ITodo> toggleTodoCompleteness(String id,bool completeness)async{
    final String? accessToken=await AuthService.instance.getAccessToken();

    if(accessToken==null)throw Exception('No access token');

    debugPrint('312312371289319');
    debugPrint('312312371289319');
    debugPrint('312312371289319');
    debugPrint('312312371289319');

    final response=await ApiClient.instance.dio.patch(
      '/auth/me/todos/$id',
      data:{
        'is_done':completeness,
      },
      options:Options(
        headers:{
          'Authorization':'Bearer $accessToken',
        },
      ),
    );

    debugPrint('JFKSJKFSDJKFSDFSDJKFSDJK');
    debugPrint('JFKSJKFSDJKFSDFSDJKFSDJK');
    debugPrint('JFKSJKFSDJKFSDFSDJKFSDJK');
    debugPrint('JFKSJKFSDJKFSDFSDJKFSDJK');

    ITodo todo=ITodo.fromMap(response.data);

    return todo;
  }

  Future<ITodo> getTodoById(String id)async{
    final String? accessToken=await AuthService.instance.getAccessToken();

    if(accessToken==null)throw Exception('No access token');

    final response=await ApiClient.instance.dio.get(
      '/auth/me/todos/$id',
      options:Options(
        headers:{
          'Authorization':'Bearer $accessToken',
        },
      ),
    );

    final ITodo todo=ITodo.fromMap(response.data);
    return todo;
  }

  Future<void> deleteTodoById(String id)async{
    final String? accessToken=await AuthService.instance.getAccessToken();

    if(accessToken==null)throw Exception('No access token');

    await ApiClient.instance.dio.delete(
      '/auth/me/todos/$id',
      options:Options(
        headers:{
          'Authorization':'Bearer $accessToken',
        },
      ),
    );
  }

  Future<void> updateTodo(ITodo todo)async{
    final String? accessToken=await AuthService.instance.getAccessToken();

    if(accessToken==null)throw Exception('No access token');

    await ApiClient.instance.dio.patch(
      '/auth/me/todos/${todo.id}',
      data:{
        'title':todo.title,
        'dueDate':todo.dueDate!=null?todo.dueDate!.toIso8601String().split('T')[0]:null,
      },
      options:Options(
        headers:{
          'Authorization':'Bearer $accessToken',
        },
      ),
    );
  }
}
