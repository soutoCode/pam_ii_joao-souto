import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ristretto/core/commons/utils/date.dart';
import 'package:ristretto/core/models/itodo.dart';
import 'package:ristretto/core/models/itodo_details_result.dart';
import 'package:ristretto/core/services/todo.dart';

class TodoScreen extends StatefulWidget{
  final String id;

  const TodoScreen({super.key,required this.id});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

enum DueDatePreset{
  today,
  tomorrow,
  custom,
}

class _TodoScreenState extends State<TodoScreen>{
  late ITodo _todo;
  bool _isLoading=false;

  @override
  void initState(){
    super.initState();

    _initializeData();
  }

  Timer? _debounce;

  void _initializeData()async{
    setState(()=>_isLoading=true);
    ITodo todo=await TodoService.instance.getTodoById(widget.id);
    setState((){
      _todo=todo;
      _isLoading=false;
    });
    _todoTitleController.text=_todo.title;

    if(_todo.dueDate==null){
      _selectedDueDatePreset=null;
      _todoDueDate=null;
    }else{
      DateTime today=DateTime.now();
      setState(()=>_todoDueDate=_todo.dueDate);
      if(sameDate(_todoDueDate!,today))
        setState(()=>_selectedDueDatePreset=DueDatePreset.today);
      else if(sameDate(_todoDueDate!,today.add(Duration(days:1))))
        setState(()=>_selectedDueDatePreset=DueDatePreset.tomorrow);
      else
        setState(()=>_selectedDueDatePreset=DueDatePreset.custom);
    }

    _todoTitleController.addListener((){
      _todo.title = _todoTitleController.text;

      if(_debounce?.isActive??false)_debounce!.cancel();
      _debounce=Timer(const Duration(milliseconds: 500),()async{
        await TodoService.instance.updateTodo(_todo);
        debugPrint('Todo updated on server: ${_todo.title}');
      });
    });
  }

  void _confirmDelete(BuildContext context){
    showDialog(
      context:context,
      builder:(context)=>AlertDialog(
        shape:RoundedRectangleBorder(
          borderRadius:BorderRadius.zero,
        ),
        title:Text('Deletar tarefa?'),
        content:Text('Você tem certeza que quer deletar permanentemente esta tarefa?'),
        actions:[
          TextButton(
            onPressed:()=>Navigator.pop(context),
            child:Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed:()=>_confirmDeletion(context),
            child:Text('Deletar'),
          ),
        ],
      ),
    );
  }

  bool _processingRequest=false;

  Future<void> _confirmDeletion(BuildContext context)async{
    Navigator.pop(context);
    setState(()=>_processingRequest=true);
    await Future.delayed(Duration(seconds:1));

    debugPrint(widget.id);
    await TodoService.instance.deleteTodoById(widget.id);

    setState(()=>_processingRequest=false);
    context.pop(TodoDetailsResult(type:TodoDetailsType.deleted));
  }


  Future<void> _toggleCompleteness(bool? value)async{
    ITodo todo=await TodoService.instance.toggleTodoCompleteness(_todo.id,value!);

    setState((){
      _todo.isComplete=todo.isComplete;
      _todo.completedAt=todo.completedAt;
    });
  }

  TextEditingController _todoTitleController=TextEditingController();

  DueDatePreset? _selectedDueDatePreset;
  DateTime? _todoDueDate=DateTime.now();

  Future<void> _openDatePicker()async{
    final picked = await showDatePicker(
      context:context,
      initialDate:_todoDueDate,
      firstDate:DateTime.now(),
      lastDate:DateTime(2100),
    );

    if(picked==null)return;

    DateTime today=DateTime.now();


    setState((){
      _todoDueDate=picked;
      _todo.dueDate=_todoDueDate;
    });

    await TodoService.instance.updateTodo(_todo);

    if(sameDate(picked,today))
      setState(()=>_selectedDueDatePreset=DueDatePreset.today);
    else if(sameDate(picked,today.add(Duration(days:1))))
      setState(()=>_selectedDueDatePreset=DueDatePreset.tomorrow);
  }
 
  void _selectDueDatePreset(DueDatePreset preset)async{
    switch(preset){
      case DueDatePreset.today:
        setState((){
          _selectedDueDatePreset=preset;
          _todoDueDate=DateTime.now();
          _todo.dueDate=_todoDueDate;
        });
        await TodoService.instance.updateTodo(_todo);
        break;
      case DueDatePreset.tomorrow:
        setState((){
          _selectedDueDatePreset=preset;
          _todoDueDate=DateTime.now().add(Duration(days:1));
          _todo.dueDate=_todoDueDate;
        });
        await TodoService.instance.updateTodo(_todo);
        break;
      case DueDatePreset.custom:
        _openDatePicker();
        setState(()=>_selectedDueDatePreset=preset);
        break;
    }
  }

  String _selectDueDateText(DueDatePreset? preset,DateTime? duedate){
    if(duedate==null)return 'Marcar prazo';
    if(preset==null)return 'Marcar prazo';

    switch(preset){
      case DueDatePreset.today:
        return 'Hoje';
      case DueDatePreset.tomorrow:
        return 'Amanhã';
      case DueDatePreset.custom:
        return formatDueDate(duedate);
    }
  }

  void _dismissDuedate()async{
    _todo.dueDate=null;
    await TodoService.instance.updateTodo(_todo);
    setState((){
      _todoDueDate=null;
      _selectedDueDatePreset=null;
    });
  }

  String getTodoDateText(ITodo todo){
    if(todo.isComplete){
      DateTime today=DateTime.now();
      if(sameDate(today,todo.completedAt!))return 'Concluído hoje';

      return 'Concluído em '+formatDueDate(todo.completedAt!);
    }

    return 'Criado '+formatCreatedAt(todo.createdAt);
  }

  @override
  Widget build(BuildContext context){
    return Stack(
      children:[
        Scaffold(
          appBar:AppBar(
            leading:IconButton(
              icon:Icon(Icons.keyboard_arrow_left),
              onPressed:(){
                context.pop(TodoDetailsResult(type:TodoDetailsType.updated,todo:_todo));
              },
            ),
          ),
          body:_isLoading
            ?Center(child:CircularProgressIndicator())
            :Column(
              children:[
                Row(
                  children:[
                    Checkbox(value:_todo.isComplete,onChanged:_toggleCompleteness,shape:CircleBorder()),
                    Expanded(
                      child:TextField(
                        controller:_todoTitleController,
                        decoration:InputDecoration(
                          border:InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child:Column(
                    children:[
                      PopupMenuButton(
                        onSelected:_selectDueDatePreset,
                        child:ListTile(
                          leading:Icon(Icons.calendar_today),
                          title:Text(
                            _selectDueDateText(_selectedDueDatePreset,_todoDueDate),
                            // style:TextStyle(),
                          ),
                          trailing:_selectedDueDatePreset==null?null:IconButton(
                            icon:Icon(Icons.close),
                            onPressed:_dismissDuedate,
                          ),
                        ),
                        itemBuilder:(context)=>[
                          PopupMenuItem(value:DueDatePreset.today,child:Text('Hoje')),
                          PopupMenuItem(value:DueDatePreset.tomorrow,child:Text('Amanhã')),
                          PopupMenuItem(value:DueDatePreset.custom,child:Text('Escolher uma data')),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children:[
                      Text(getTodoDateText(_todo)),
                      IconButton(
                        icon:Icon(Icons.delete),
                        onPressed:()=>_confirmDelete(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ),
        if(_processingRequest)
          Positioned.fill(
            child:Container(
              color:Colors.black.withValues(alpha:0.5),
              child:Center(
                child:CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
