import 'package:flutter/material.dart';

import 'package:ristretto/core/routes/router.dart';
import 'package:ristretto/core/themes/global.dart';

void main(){
  runApp(MyApp());
}

// Root App
class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp.router(
      debugShowCheckedModeBanner:false,
      routerConfig:router,
      theme:globalTheme,
    );
  }
}
