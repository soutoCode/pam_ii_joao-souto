import 'package:flutter/material.dart';
import 'package:ristretto/core/commons/utils/date.dart';

class TodoItem extends StatelessWidget{
  final String title;
  final bool isComplete;
  final String? categoryName;
  final DateTime? dueDate;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onTap;
  final bool isSelected;
  final ValueChanged<bool?> onToggleCompleteness;

  const TodoItem({
    super.key,
    required this.title,
    required this.isComplete,
    this.categoryName,
    required this.dueDate,
    required this.isSelected,
    this.onTap,
    this.onLongPress,
    required this.onToggleCompleteness,
  });

  Widget? _buildMetadata(String? categoryName,DateTime? duedate){
    if(categoryName==null&&dueDate==null)return null;

    if(duedate==null)
      return Text(
        categoryName!,
        style:TextStyle(color:Colors.blueGrey),
      );

    final _formattedDueDate=formatDueDate(dueDate!);
    final DateTime today=DateTime.now();

    Color _dueDateColor=Colors.blueGrey;

    if(sameDate(dueDate!,today))_dueDateColor=Colors.cyanAccent;
    else if(isBeforeDateOnly(dueDate!,today))_dueDateColor=Colors.red;

    if(categoryName==null)
      return Text(
        _formattedDueDate,
        style:TextStyle(color:_dueDateColor),
      );

    return Row(
      children:[
        Text(
          categoryName,
          style:TextStyle(color:Colors.blueGrey),
        ),
        const Text(' • ',style:TextStyle(color:Colors.blueGrey)),
        Text(
          _formattedDueDate,
          style:TextStyle(color:_dueDateColor),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    return Container(
      color:isSelected?Colors.blue.withValues(alpha:0.3):Colors.transparent,
      child:ListTile(
        leading:Transform.scale(
          scale:1.2,
          child:Checkbox(
            value:isComplete,
            onChanged:onToggleCompleteness,
            shape:CircleBorder(),
          ),
        ),
        onTap:onTap,
        onLongPress:onLongPress,
        title:Text(title),
        subtitle:_buildMetadata(categoryName,dueDate),
      ),
    );
  }
}
