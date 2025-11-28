import 'package:flutter/material.dart';
import 'package:ristretto/core/commons/utils/color.dart';

class CalendarTodo extends StatelessWidget{
  final String title;
  final String color;
  final bool isDone;
  final String categoryName;
  final ValueChanged<bool?> onToggleCompleteness;

  const CalendarTodo({
    super.key,
    required this.title,
    required this.color,
    required this.onToggleCompleteness,
    required this.isDone,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context){
    return Container(
      padding:const EdgeInsets.all(16),
      decoration:BoxDecoration(
        color:fromHex(color),
        borderRadius:BorderRadius.circular(8),
      ),
      child:IntrinsicHeight(
        child:ListTile(
          title:Text(
            title,
            style:Theme.of(context).textTheme.headlineSmall,
          ),
          subtitle:Text(
            categoryName,
            style:TextStyle(
              fontSize:16,
              color:Colors.blueGrey,
            ),
          ),
          trailing:Transform.scale(
            scale:1.5,
            child:Checkbox(
              value:isDone,
              onChanged:onToggleCompleteness,
              shape:CircleBorder(),
            ),
          ),
        ),
      ),
    );
  }
}
