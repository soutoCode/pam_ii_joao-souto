import 'package:flutter/material.dart';
import 'package:ristretto/core/models/icategory.dart';

class SelectCategoryDialog extends StatelessWidget {
  final List<ICategory> categories;

  const SelectCategoryDialog({
    super.key,
    required this.categories,
  });

  void _selectCategory(BuildContext context,ICategory category){
    Navigator.pop(context,category);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.all(16),
      child:ConstrainedBox(
        constraints:BoxConstraints(maxHeight:400),
        child:ListView.builder(
          shrinkWrap:true,
          itemCount:categories.length,
          itemBuilder:(context,index){
            final ICategory category=categories[index];
        
            return ListTile(
              onTap:()=>_selectCategory(context,category),
              leading:Icon(Icons.school),
              title:Text(category.name),
            );
          },
        ),
      ),
    );
  }
}
