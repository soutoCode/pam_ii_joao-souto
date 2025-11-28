import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ristretto/core/commons/utils/date.dart';
import 'package:ristretto/core/models/icategory.dart';

import 'package:ristretto/core/models/itodo.dart';
import 'package:ristretto/core/models/itodo_details_result.dart';
import 'package:ristretto/core/routes/main_app.dart';
import 'package:ristretto/core/services/category.dart';
import 'package:ristretto/core/services/todo.dart';
import 'package:ristretto/core/themes/colors.dart';
import 'package:ristretto/features/todos/presentation/add_todo_dialog.dart';
import 'package:ristretto/features/todos/presentation/todo_item.dart';
import 'package:ristretto/core/enums/todo_filter.dart';
import 'package:ristretto/features/todos/presentation/todo_list.dart';

class TodosScreen extends StatefulWidget{
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen>{
  bool _isLoading=true;
  List<ITodo> _todos=[];
  TodoFilter _todoFilter=TodoFilter.all;
  int _totalTodos=0;

  Future<void> _fetchTodos()async{
    await Future.delayed(Duration(seconds:1));
    setState(()=>_isLoading=true);

    List<ITodo> todos=await TodoService.instance.getTodos(filter:_todoFilter);
    int x=0;

    todos.forEach((todo){
      if(sameDate(todo.dueDate!,DateTime.now()))x++;
    });

    setState((){
      _todos=todos;
      _isLoading=false;
      _totalTodos=x;
    });
  }

  List<ICategory> _categories=[];

  Future<void> _fetchCategories()async{
    _categories=await CategoryService.instance.getCategories();
  }

  Future<void> _fetchInitialData()async{
    await _fetchCategories();
    _fetchTodos();
  }

  @override
  void initState(){
    super.initState();
    _fetchInitialData();
  }

  bool _processingRequest=false;

  Future<void> _addTodo(String title,DateTime? duedate,ICategory? category)async{
    setState(()=>_processingRequest=true);

    ITodo newTodo=await TodoService.instance.create(title,duedate,category!.id);
    newTodo.category=category;

    setState((){
      _processingRequest=false;
      _todos.add(newTodo);
    });
  }

  Future<void> _selectFilter(TodoFilter value)async{
    setState(()=>_todoFilter=value);
    await _fetchTodos();
  }

  void _openAddTodoDialog(BuildContext context){
    showModalBottomSheet(
      context:context,
      shape:RoundedRectangleBorder(
        borderRadius:BorderRadius.zero,
      ),
      builder:(context){
        // WidgetsBinding.instance.addPostFrameCallback((_){
        //   FocusScope.of(context).requestFocus(_todoTitleFocus);
        // });

        return AddTodoDialog(
          categories:_categories,
          onSubmit:_addTodo,
        );
      }
    );
  }

  List<String> selectedTodosId=[];
  bool selectionMode=false;

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
          debugPrint('title: '+x.title);
          debugPrint('isComplete: '+x.isComplete.toString());
          debugPrint('duedate'+x.dueDate.toString());
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

  void _cancelSelection(){
    setState((){
      selectionMode=false;
      selectedTodosId.clear();
    });
  }

  Future<void> _confirmDeletion(BuildContext context)async{
    Navigator.pop(context);
    setState(()=>_processingRequest=true);

    await TodoService.instance.deleteTodosById(selectedTodosId);

    setState(()=>_processingRequest=false);

    setState((){
      _todos.removeWhere((todo)=>selectedTodosId.contains(todo.id));
      selectedTodosId.clear();
      selectionMode=false;
    });
  }

  void _confirmDelete(BuildContext context){
    showDialog(
      context:context,
      builder:(context)=>AlertDialog(
        shape:RoundedRectangleBorder(
          borderRadius:BorderRadius.zero,
        ),
        title:Text('Deletar tarefas?'),
        content:selectedTodosId.length==1
          ?Text('Você tem certeza que quer deletar permanentemente esta tarefa?')
          :Text('Você tem certeza que quer deletar permanentemente estas tarefas?'),
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

  Future<void> _toggleTodoCompleteness(ITodo todo,bool? completeness)async{
    if(completeness==null)return;

    await TodoService.instance.toggleTodoCompleteness(todo.id,completeness);

    setState(()=>todo.isComplete=completeness);
  }

  @override
  Widget build(BuildContext context){
    return Stack(
      children:[
        MainApp(
          appBar:selectionMode
            ?AppBar(
              leading:Row(
                children:[
                  IconButton(
                    onPressed:_cancelSelection,
                    icon:Icon(Icons.cancel),
                  ),
                  Text(selectedTodosId.length.toString()),
                ],
              ),
              actions:[
                IconButton(
                  onPressed:()=>_confirmDelete(context),
                  icon:Icon(Icons.delete),
                )
              ],
            )
            :null,
          floatingActionButton:FloatingActionButton(
            onPressed:()=>_openAddTodoDialog(context),
            child:Icon(Icons.add),
          ),
          child:Stack(
            children:[
              _isLoading
                ?Center(child:CircularProgressIndicator())
                :Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children:[
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child:Column(
                        crossAxisAlignment:CrossAxisAlignment.start,
                        children:[
                          Text('Minhas Tarefas',style:TextStyle(fontSize:32,fontWeight:FontWeight.w600)),
                          Text.rich(
                            TextSpan(
                              text:'${_totalTodos} tarefas para ',
                              style:Theme.of(context).textTheme.headlineSmall,
                              children:[
                                const TextSpan(
                                  text:'hoje',
                                  style:TextStyle(color:AppColors.primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child:ListView.builder(
                        itemCount:_categories.length,
                        itemBuilder:(context,index){
                          final ICategory category=_categories[index];
                          return TodoList(category: category);
                        }
                      ),
                    ),
                  ],
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
