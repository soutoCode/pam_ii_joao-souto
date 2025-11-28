import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ristretto/core/commons/utils/icon.dart';
import 'package:ristretto/core/models/icategory.dart';

import 'package:ristretto/core/models/itodo.dart';
import 'package:ristretto/core/models/itodo_details_result.dart';
import 'package:ristretto/core/services/category.dart';
import 'package:ristretto/core/services/todo.dart';
import 'package:ristretto/features/categories/presentation/create_category_dialog.dart';
import 'package:ristretto/features/todos/presentation/add_todo_dialog.dart';
import 'package:ristretto/features/todos/presentation/todo_item.dart';

class CategoryScreen extends StatefulWidget{
  final String initialName;
  final String id;

  const CategoryScreen({super.key,required this.id,required this.initialName});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>{
  bool _isLoading=true;
  List<ITodo> _todos=[];
  ICategory _category=ICategory(id:'',name:'',color:'',type:'');

  Future<void> _initializeData()async{
    List<ITodo> todos=await TodoService.instance.getTodosByCategoryId(widget.id);
    ICategory category=await CategoryService.instance.getCategoryById(widget.id);

    setState((){
      _todos=todos;
      _category=category;
      _isLoading=false;
    });
  }

  @override
  void initState(){
    super.initState();
    setState(()=>_category.name=widget.initialName);
    debugPrint(_category.name);
    _initializeData();
  }

  bool _processingRequest=false;

  Future<void> _openDeleteConfirmationDialog(BuildContext context)async{
    bool shouldDelete=await showDialog(
      context:context,
      builder:(context){
        return AlertDialog(
          shape:RoundedRectangleBorder(
            borderRadius:BorderRadius.zero,
          ),
          title:Text('Você tem certeza?'),
          content:Text('"${_category.name}" vai ser permanentemente excluído.'),
          actions:[
            TextButton(
              onPressed:()=>Navigator.pop(context,false),
              child:Text('CANCELAR'),
            ),
            TextButton(
              onPressed:()=>Navigator.pop(context,true),
              child:Text('DELETAR',style:TextStyle(color:Colors.red)),
            ),
          ],
        );
      },
    );

    if(shouldDelete){
      setState(()=>_processingRequest=true);
      await CategoryService.instance.deleteCategoryById(widget.id);
      setState(()=>_processingRequest=false);
      context.go('/categories');
    }
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

  Future<void> _confirmDeletion(BuildContext context)async{
    Navigator.pop(context);
    setState(()=>_processingRequest=true);

    await Future.delayed(Duration(seconds:1));
    await TodoService.instance.deleteTodosById(selectedTodosId);

    setState((){
      _processingRequest=false;
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

  Future<void> _addTodo(String title,DateTime? duedate,ICategory? category)async{
    setState(()=>_processingRequest=true);

    ITodo newTodo=await TodoService.instance.create(title,duedate,widget.id);
    newTodo.category=category;

    setState((){
      _processingRequest=false;
      _todos.add(newTodo);
    });
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
          onSubmit:_addTodo,
        );
      }
    );
  }

  void _openEditCategoryDialog(BuildContext context)async{
    final result=await showDialog(
      context:context,
      builder:(context)=>CreateCategoryDialog(
        title:'Renomear categoria',
        confirmationButtonText:'Salvar',
        initialTitle:_category.name,
      ),
    );
    String name=result['name'];
    Color color=result['color'];

    setState(()=>_processingRequest=true);
    await CategoryService.instance.updateCategoryById(widget.id,name,color);
    setState((){
      _processingRequest=false;
      _category.name=name;
    });
  }

  @override
  Widget build(BuildContext context){
    return Stack(
      children:[
        Scaffold(
          appBar:
            selectionMode
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
              :AppBar(
                leading:IconButton(
                  icon:Icon(Icons.keyboard_arrow_left),
                  onPressed:(){
                    context.go('/categories');
                  },
                ),
                actions:[
                  PopupMenuButton(
                    icon:Icon(Icons.more_vert),
                    itemBuilder:(context)=>[
                      PopupMenuItem(
                        child:Row(
                          children:[
                            Icon(Icons.edit),
                            SizedBox(width:8),
                            Text('Editar categoria'),
                          ],
                        ),
                        onTap:()=>_openEditCategoryDialog(context),
                      ),
                      PopupMenuItem(
                        onTap:()=>_openDeleteConfirmationDialog(context),
                        child:Row(
                          children:[
                            Icon(Icons.delete),
                            SizedBox(width:8),
                            Text('Deletar categoria'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          body:
            Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children:[
                Padding(
                  padding:const EdgeInsets.only(left:24),
                  child: Row(
                    children: [
                      Icon(iconMap[_category.icon],size:40),
                      SizedBox(width:8),
                      Text(
                        _category.name,
                        style:TextStyle(fontSize:32,fontWeight:FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child:_isLoading
                  ?Center(child:CircularProgressIndicator())
                  :ListView.builder(
                    itemCount:_todos.length,
                    itemBuilder:(context,index){
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
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton:FloatingActionButton(
              onPressed:(){
                _openAddTodoDialog(context);
              },
              child:Icon(Icons.add),
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
