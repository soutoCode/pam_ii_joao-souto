import 'package:go_router/go_router.dart';
import 'package:ristretto/core/enums/theme.dart';
import 'package:ristretto/core/models/register_form_data.dart';
import 'package:ristretto/features/calendar/presentation/calendar.dart';
import 'package:ristretto/features/category/presentation/category_screen.dart';
import 'package:ristretto/features/register/presentation/register_step1_screen.dart';
import 'package:ristretto/features/register/presentation/register_step2_screen.dart';
import 'package:ristretto/features/todo/presentation/todo_screen.dart';

// Main App Screens
import 'package:ristretto/features/todos/presentation/todos_screen.dart';
import 'package:ristretto/features/categories/presentation/categories_screen.dart';
import 'package:ristretto/features/user/presentation/user_screen.dart';
import 'package:ristretto/features/settings/presentation/settings_screen.dart';

// Authentication Screens
import 'package:ristretto/features/login/presentation/login_screen.dart';

// Router
final GoRouter router=GoRouter(
  initialLocation:'/login',
  routes:[
    GoRoute(
      path:'/todos',
      builder:(context,state)=>TodosScreen(),
    ),
    GoRoute(
      path:'/calendar',
      builder:(context,state)=>CalendarScreen(),
    ),
    GoRoute(
      path:'/categories',
      builder:(context,state)=>CategoriesScreen(),
    ),
    GoRoute(
      path:'/user',
      builder:(context,state)=>UserScreen(),
    ),
    GoRoute(
      path:'/user/settings',
      builder:(context,state){
        TheTheme theme=(state.extra as Map)['theme'] as TheTheme;
        return SettingsScreen(theme:theme);
      },
    ),
    GoRoute(
      path:'/categories/:id',
      builder:(context,state){
        final String categoryId=state.pathParameters['id']!;
        final String initialName=state.extra as String;

        return CategoryScreen(id:categoryId,initialName:initialName);
      },
    ),
    GoRoute(
      path:'/todos/:id',
      builder:(context,state){
        final String todoId=state.pathParameters['id']!;

        return TodoScreen(id:todoId);
      },
    ),
    // Authentication routing
    GoRoute(
      path:'/login',
      builder:(context,state)=>LoginScreen(),
    ),
    GoRoute(
      path:'/register/step-1',
      builder:(context,state){
        final RegisterFormData? persist=state.extra as RegisterFormData?;
        return RegisterStep1Screen(persist);
      },
    ),
    GoRoute(
      path:'/register/step-2',
      builder:(context,state){
        final RegisterFormData? persist=state.extra as RegisterFormData?;
        return RegisterStep2Screen(persist);
      },
    ),
  ],
);
