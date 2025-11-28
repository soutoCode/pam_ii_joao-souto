import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ristretto/core/models/icategory.dart';
import 'package:ristretto/core/routes/main_app.dart';
import 'package:ristretto/core/services/category.dart';
import 'package:ristretto/features/categories/presentation/create_category_dialog.dart';
import 'package:ristretto/features/categories/presentation/list_skeleton.dart';

class CategoriesScreen extends StatefulWidget{
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>{
  bool _isLoading=true;
  List<ICategory> _categories=[];

  Future<void> _initializeData()async{
    await Future.delayed(Duration(seconds:1));
    List<ICategory> categories=await CategoryService.instance.getCategories();

    // categories.forEach((category){
    //   debugPrint(category.color);
    //   debugPrint(category.type);
    // });

    setState((){
      _isLoading=false;
      _categories=categories;
    });
  }

  @override
  void initState(){
    super.initState();
    _initializeData();
  }

  Future<void> _openCreateCategoryDialog(BuildContext context)async{
    final result=await showDialog(
      context:context,
      builder:(context)=>CreateCategoryDialog(
        title:'Nova categoria',
        confirmationButtonText:'CRIAR',
      ),
    );
    String name=result['name'];
    Color color=result['color'];
    String? icon=result['icon'];

    setState(()=>_processingRequest=true);
    ICategory newCategory=await CategoryService.instance.create(name:name,color:color,icon:icon);
    setState((){
      _categories.add(newCategory);
      _processingRequest=false;
    });
  }

  bool _processingRequest=false;

  @override
  Widget build(BuildContext context){
    return Stack(
      children:[
        MainApp(
          floatingActionButton:FilledButton.icon(
            onPressed:()=>_openCreateCategoryDialog(context),
            icon:Icon(Icons.add),
            label:Text('Nova Lista'),
          ),
          child:_isLoading
            ?Center(child:CircularProgressIndicator())
            :Padding(
              padding:const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children:[
                  Text('Listas',style:TextStyle(fontSize:32,fontWeight:FontWeight.w600)),
                  Expanded(
                    child:GridView.count(
                      crossAxisCount:2,
                      mainAxisSpacing:10,
                      crossAxisSpacing:10,
                      children:List.generate(
                        _categories.length,
                        (index){
                          ICategory category=_categories[index];
                          return GestureDetector(
                            onTap:()=>context.go('/categories/${category.id}',extra:category.name),
                            child:ListSkeleton(
                              name:category.name,
                              color:category.color,
                              icon:category.icon,
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                ],
              ),
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
