import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ristretto/core/themes/colors.dart';

// Navigation Bar Items
final List<BottomNavigationBarItem> _navItems=[
  BottomNavigationBarItem(
    label:'',
    icon:Icon(Icons.done_all),
  ),
  BottomNavigationBarItem(
    label:'',
    icon:Icon(Icons.calendar_month),
  ),
  BottomNavigationBarItem(
    label:'',
    icon:Icon(Icons.list),
  ),
  BottomNavigationBarItem(
    label:'',
    icon:Icon(Icons.person),
  ),
];

// Main App with Common Navigation Bar
class MainApp extends StatelessWidget{
  final Widget child;
  final AppBar? appBar;
  final Widget? floatingActionButton;

  const MainApp({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
  });

  int _getCurrentIndex(String location){
    switch(location){
      case '/todos':
        return 0;
      case '/calendar':
        return 1;
      case '/categories':
        return 2;
      case '/user':
        return 3;
    }

    throw Exception('invalid location');
  }

  void _changeScreen(BuildContext context,int index){
    switch(index){
      case 0:
        context.go('/todos');
        break;
      case 1:
        context.go('/calendar');
        break;
      case 2:
        context.go('/categories');
        break;
      case 3:
        context.go('/user');
        break;
    }
  }

  @override
  Widget build(BuildContext context){
    final String location=GoRouterState.of(context).uri.toString();

    int currentIndex=_getCurrentIndex(location);

    return Scaffold(
      appBar:appBar,
      body:SafeArea(child:child),
      bottomNavigationBar:BottomNavigationBar(
        selectedItemColor:AppColors.primaryColor,
        type:BottomNavigationBarType.fixed,
        items:_navItems,
        currentIndex:currentIndex,
        onTap:(index)=>_changeScreen(context,index),
      ),
      floatingActionButton:floatingActionButton,
    );
  }
}
