import 'package:flutter/material.dart';
import 'package:ristretto/core/commons/utils/icon.dart';

class CategoryItem extends StatelessWidget{
  final String name;
  final String? icon;

  const CategoryItem({super.key,required this.name,this.icon});

  @override
  Widget build(BuildContext context){
    return ListTile(
      leading:icon!=null?Icon(iconMap[icon]):null,
      title:Text(name),
    );
  }
}
