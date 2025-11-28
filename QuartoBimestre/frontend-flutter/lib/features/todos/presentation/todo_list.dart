import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ristretto/core/commons/utils/icon.dart';
import 'package:ristretto/core/models/icategory.dart';
import 'package:ristretto/core/models/itodo.dart';
import 'package:ristretto/core/models/itodo_details_result.dart';
import 'package:ristretto/core/services/todo.dart';
import 'package:ristretto/features/todos/presentation/todo_item.dart';

class TodoList extends StatefulWidget {
  const TodoList({
    super.key,
    required this.category,
  });

  final ICategory category;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList>{
  List<ITodo> _todos=[];
  bool _isOpen=false;

  void fetchInitialData()async{
    final result=await TodoService.instance.getTodosByCategoryId(widget.category.id);
    setState(()=>_todos=result);
  }

  @override
  void initState(){
    super.initState();
    fetchInitialData();
  }

  void _onTapTodo(ITodo todo)async{
    if(selectionMode){
      setState((){
        if(selectedTodosId.contains(todo.id)){
          selectedTodosId.remove(todo.id);
          if(selectedTodosId.isEmpty)selectionMode=false;
        }else{
          selectedTodosId.add(todo.id);
        }
      });
    }else{
      final TodoDetailsResult? result=await context.push<TodoDetailsResult>('/todos/${todo.id}');

      if(result==null)return;
      switch(result.type){
        case TodoDetailsType.deleted:
          setState(()=>_todos.removeWhere((t)=>t.id==todo.id));
          break;
        case TodoDetailsType.updated:
          final ITodo x=result.todo!;
          setState((){
            todo.title=x.title;
            todo.isComplete=x.isComplete;
            todo.dueDate=x.dueDate;
          });
          break;
      }
    }

  }

  void _onLongPressTodo(ITodo todo){
    setState((){
      selectionMode=true;
      selectedTodosId.add(todo.id);
    });
  }

  Future<void> _toggleTodoCompleteness(ITodo todo,bool? completeness)async{
    if(completeness==null)return;

    await TodoService.instance.toggleTodoCompleteness(todo.id,completeness);

    setState(()=>todo.isComplete=completeness);
  }

  void _cancelSelection(){
    setState((){
      selectionMode=false;
      selectedTodosId.clear();
    });
  }

  List<String> selectedTodosId=[];
  bool selectionMode=false;

  @override
  Widget build(BuildContext context){
    return Column(
      children:[
        Row(
          children:[
            IconButton(
              onPressed:()=>setState(()=>_isOpen=!_isOpen),
              icon:Transform.rotate(
                angle:_isOpen?pi/2:0,
                child:Icon(Icons.chevron_right)
              ),
            ),
            Icon(iconMap[widget.category.icon]),
            SizedBox(width:12),
            Text(widget.category.name),
            SizedBox(width:12),
            Text(_todos.length.toString()),
          ],
        ),
        AnimatedSize(
          duration:Duration(milliseconds:267),
          child:SizedBox(
            height:_isOpen?null:0,
            child: Column(
              children:List.generate(
                _todos.length,
                (index){
                  final ITodo todo=_todos[index];
                  final isSelected=selectedTodosId.contains(todo.id);
            
                  return TodoItem(
                    title:todo.title,
                    isComplete:todo.isComplete,
                    dueDate:todo.dueDate,
                    isSelected:isSelected,
                    onTap:()=>_onTapTodo(todo),
                    onLongPress:()=>_onLongPressTodo(todo),
                    onToggleCompleteness:(newValue)=>_toggleTodoCompleteness(todo,newValue),
                  );
                }
              ),
            ),
          ),
        ),
      ],
    );
  }
}
