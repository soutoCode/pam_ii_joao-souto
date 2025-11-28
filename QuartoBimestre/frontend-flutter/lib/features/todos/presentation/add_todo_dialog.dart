import 'package:flutter/material.dart';
import 'package:ristretto/core/commons/utils/date.dart';
import 'package:ristretto/core/models/icategory.dart';
import 'package:ristretto/features/todos/presentation/select_category_dialog.dart';

class AddTodoDialog extends StatefulWidget{
  final List<ICategory>? categories;
  final void Function(String title,DateTime? duedate,ICategory? category) onSubmit;

  const AddTodoDialog({
    super.key,
    required this.onSubmit,
    this.categories
  });

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

enum DueDatePreset{
  today,
  tomorrow,
  custom,
}

class _AddTodoDialogState extends State<AddTodoDialog>{
  DateTime? _todoDueDate=DateTime.now();
  String _todoTitle='';
  ICategory? _todoCategory;

  DueDatePreset _selectedDueDatePreset=DueDatePreset.today;
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  final FocusNode _todoTitleFocus=FocusNode();

  Future<void> _openDatePicker()async{
    final picked = await showDatePicker(
      context:context,
      initialDate:_todoDueDate,
      firstDate:DateTime.now(),
      lastDate:DateTime(2100),
    );

    if(picked==null)return;

    DateTime today=DateTime.now();

    setState(()=>_todoDueDate=picked);

    if(sameDate(picked,today))
      setState(()=>_selectedDueDatePreset=DueDatePreset.today);
    else if(sameDate(picked,today.add(Duration(days:1))))
      setState(()=>_selectedDueDatePreset=DueDatePreset.tomorrow);
  }

  void _selectDueDatePreset(DueDatePreset preset){
    switch(preset){
      case DueDatePreset.today:
        setState((){
          _selectedDueDatePreset=preset;
          _todoDueDate=DateTime.now();
        });
        break;
      case DueDatePreset.tomorrow:
        setState((){
          _selectedDueDatePreset=preset;
          _todoDueDate=DateTime.now().add(Duration(days:1));
        });
        break;
      case DueDatePreset.custom:
        _openDatePicker();
        setState(()=>_selectedDueDatePreset=preset);
        break;
    }
  }

  String _selectDueDateText(DueDatePreset preset,DateTime? duedate){
    if(duedate==null)return 'Marcar prazo';

    switch(preset){
      case DueDatePreset.today:
        return 'Hoje';
      case DueDatePreset.tomorrow:
        return 'Amanhã';
      case DueDatePreset.custom:
        return formatDueDate(duedate!);
    }
  }

  Future<void> _addTodo()async{
    _formKey.currentState!.save();
    Navigator.of(context).pop();
    widget.onSubmit(_todoTitle,_todoDueDate,_todoCategory);
  }

  Future<void> _openSelectCategoryDialog(BuildContext context)async{
    ICategory selectedCategory=await showModalBottomSheet(
      context:context,
      shape:RoundedRectangleBorder(
        borderRadius:BorderRadius.zero,
      ),
      builder:(context){
        return SelectCategoryDialog(categories:widget.categories!);
      },
    );

    setState(()=>_todoCategory=selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom:MediaQuery.of(context).viewInsets.bottom+16,
        left:16,
        right:16,
        top:16,
      ),
      child:Form(
        key:_formKey,
        child:Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          mainAxisSize:MainAxisSize.min,
          children:[
            Row(
              spacing:16,
              children:[
                Expanded(
                  child:TextFormField(
                    decoration:InputDecoration(
                      border:InputBorder.none,
                      hintText:'Adicione uma tarefa',
                    ),
                    focusNode:_todoTitleFocus,
                    textInputAction:TextInputAction.done,
                    onSaved:(value)=>_todoTitle=value!,
                  ),
                ),
                Container(
                  decoration:BoxDecoration(
                    color:Colors.black,
                    borderRadius:BorderRadius.circular(8),
                  ),
                  child:IconButton(
                    color:Colors.white,
                    icon:Icon(Icons.arrow_upward),
                    onPressed:_addTodo,
                  ),
                ),
              ],
            ),
            SizedBox(height:8),
            SingleChildScrollView(
              scrollDirection:Axis.horizontal,
              child:Row(
                crossAxisAlignment:CrossAxisAlignment.start,
                spacing:16,
                children:[
                  if(widget.categories!=null)
                    GestureDetector(
                      onTap:()=>_openSelectCategoryDialog(context),
                      child:Container(
                        padding:const EdgeInsets.symmetric(vertical:8,horizontal:16),
                        decoration:BoxDecoration(
                          color:Colors.white,
                          border:BoxBorder.all(color:Colors.black),
                          borderRadius:BorderRadius.circular(32),
                        ),
                        child:Row(
                          mainAxisSize:MainAxisSize.min,
                          children:[
                            Icon(Icons.list),
                            SizedBox(width:8),
                            Text(_todoCategory!=null?_todoCategory!.name:'Escolher lista'),
                          ],
                        ),
                      ),
                    ),
                  PopupMenuButton<DueDatePreset>(
                    position:PopupMenuPosition.over,
                    onSelected:_selectDueDatePreset,
                    child:Container(
                      padding:const EdgeInsets.symmetric(vertical:8,horizontal:16),
                      decoration:BoxDecoration(
                        color:_todoDueDate==null?Colors.white:Colors.black,
                        border:BoxBorder.all(color:Colors.black),
                        borderRadius:BorderRadius.circular(32),
                      ),
                      child:Row(
                        mainAxisSize:MainAxisSize.min,
                        children:[
                          Icon(Icons.calendar_today,color:_todoDueDate==null?Colors.black:Colors.white),
                          SizedBox(width:8),
                          Text(
                            _selectDueDateText(_selectedDueDatePreset,_todoDueDate),
                            style:TextStyle(color:_todoDueDate==null?Colors.black:Colors.white),
                          ),
                          if(_todoDueDate!=null)...[
                            SizedBox(width:8),
                            GestureDetector(
                              onTap:()=>setState(()=>_todoDueDate=null),
                              child:Icon(Icons.close,color:Colors.white),
                            )]
                        ],
                      ),
                    ),
                    itemBuilder:(_)=>[
                      PopupMenuItem(value:DueDatePreset.today,child:Text('Hoje')),
                      PopupMenuItem(value:DueDatePreset.tomorrow,child:Text('Amanhã')),
                      PopupMenuItem(value:DueDatePreset.custom,child:Text('Escolher uma data')),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
