import 'package:flutter/material.dart';
import 'package:ristretto/core/themes/colors.dart';

final ThemeData globalTheme=ThemeData(
  fontFamily:'Gabarito',
  colorScheme:ColorScheme.fromSeed(
    seedColor:AppColors.primaryColor,
  ),
  textTheme:const TextTheme(
    headlineLarge:TextStyle(
      height:1,
      fontWeight:FontWeight.w600,
      fontSize:32,
    ),
    headlineMedium:TextStyle(
      height:1,
      fontWeight:FontWeight.w500,
      fontSize:24,
    ),
    headlineSmall:TextStyle(
      height:1,
      fontWeight:FontWeight.w400,
      fontSize:20,
    ),
  ),
);
