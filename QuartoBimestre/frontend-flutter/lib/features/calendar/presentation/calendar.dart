import 'package:flutter/material.dart';
import 'package:ristretto/core/commons/utils/date.dart';
import 'package:ristretto/core/enums/todo_filter.dart';
import 'package:ristretto/core/models/icategory.dart';
import 'package:ristretto/core/models/itodo.dart';
import 'package:ristretto/core/routes/main_app.dart';
import 'package:ristretto/core/services/category.dart';
import 'package:ristretto/core/services/todo.dart';

import 'package:ristretto/core/themes/colors.dart';
import 'package:ristretto/features/calendar/presentation/calendar_todo.dart';
import 'package:ristretto/features/todos/presentation/add_todo_dialog.dart';

class CalendarScreen extends StatefulWidget{
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState()=>_CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>{
  List<ITodo> _todos=[];
  bool _isLoading=true;
  List<ICategory> _categories=[];

  void _initializeData()async{
    await Future.delayed(Duration(seconds:1));
    _categories=await CategoryService.instance.getCategories();
    List<ITodo> result=await TodoService.instance.getTodos(filter:TodoFilter.today);

    setState((){
      _todos=result;
      _isLoading=false;
    });
  }

  @override
  void initState(){
    super.initState();
    _initializeData();
  }

  // Set current day to today by default
  DateTime currentDay=DateTime.now();

  Text _buildCurrentMonth(BuildContext context){
    return Text(
      getCurrentMonth(currentDay),
      style:Theme.of(context).textTheme.headlineLarge,
    );
  }

  Row _buildDateNavigation(BuildContext context){
    return Row(
      mainAxisAlignment:MainAxisAlignment.center,
      children:[
        // Button to navigate back one day
        GestureDetector(
          onTap:(){
            // setState(()=>currentDay=currentDay.add(Duration(days:-1)));
          },
          child: Icon(
            Icons.arrow_left,
            color:AppColors.primaryColor,
          ),
        ),
        // Show current day
        Text(
          // formatDay(today,currentDay),
          'Hoje',
          style:Theme.of(context).textTheme.headlineSmall!.copyWith(
            color:AppColors.primaryColor,
          ),
        ),
        // Button to navigate forward one day
        GestureDetector(
          onTap:(){
            // setState(()=>currentDay=currentDay.add(Duration(days:1)));
          },
          child:Icon(
            Icons.arrow_right,
            color:AppColors.primaryColor,
          ),
        )
      ],
    );
  }

  Text _buildCurrentDay(){
    return Text(
      '${currentDay.day}',
      style:TextStyle(
        height:1,
        fontWeight:FontWeight.w400,
        fontSize:48,
      ),
    );
  }

  Expanded _buildTodayTodos(){
    return Expanded(
      child:Column(
        spacing:10,
        children:_todos
          .map((todo)=>
            CalendarTodo(
              title:todo.title,
              color:todo.category!.color,
              onToggleCompleteness:(value)=>_toggleTodoCompleteness(todo,value),
              isDone:todo.isComplete,
              categoryName:todo.category!.name,
            ),
          )
          .toList(),
      ),
    );
  }

  Future<void> _toggleTodoCompleteness(ITodo todo,bool? completeness)async{
    if(completeness==null)return;

    await TodoService.instance.toggleTodoCompleteness(todo.id,completeness);

    setState(()=>todo.isComplete=completeness);
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

  @override
  Widget build(BuildContext context){
    return
      MainApp(
        child:_isLoading
          ?Center(child:CircularProgressIndicator())
          :Padding(
            padding:const EdgeInsets.all(16),
            child: Column(
              spacing:16,
              children:[
                Column(
                  spacing:10,
                  children:[
                    _buildCurrentMonth(context),
                    _buildDateNavigation(context),
                  ],
                ),
                Expanded(
                  child:Container(
                    padding:const EdgeInsets.all(16),
                    decoration:BoxDecoration(
                      borderRadius:BorderRadius.circular(8),
                      border:BoxBorder.all(
                        color:Color(0xFFD9D9D9),
                        width:2,
                      ),
                    ),
                    child:Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      spacing:24,
                      children:[
                        _buildCurrentDay(),
                        Expanded(child:SingleChildScrollView(child:_buildTodayTodos())),
                        // Button to Add new task for current day
                        Align(
                          alignment:Alignment.center,
                          child:IconButton(
                            onPressed:()=>_openAddTodoDialog(context),
                            icon:Icon(Icons.add)
                          ),
                        ),
                      ],
                    ),
                  )
                ),
              ],
            ),
          ),
      );
  }
}
