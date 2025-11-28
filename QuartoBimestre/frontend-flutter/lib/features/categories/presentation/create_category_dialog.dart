import 'package:flutter/material.dart';
import 'package:ristretto/core/commons/utils/icon.dart';

List<Color> colors=[
  Color(0XFF0057D9),
  Color(0xFFD62828),
  Color(0xFF2ECC71),
  Color(0xFF6C63FF),
  Color(0xFFF39C12),
  Color(0xFF00B5AD),
  Color(0xFF2C3E50),
];


class CreateCategoryDialog extends StatefulWidget{
  final String title;
  final String confirmationButtonText;
  final String? initialTitle;

  const CreateCategoryDialog({
    super.key,
    required this.title,
    required this.confirmationButtonText,
    this.initialTitle,
  });

  @override
  State<CreateCategoryDialog> createState() => _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends State<CreateCategoryDialog>{
  final _categoryNameController=TextEditingController();
  Color _selectedColor=colors[0];
  String? _selectedIcon;

  Future<void> _createCategory(BuildContext context)async{
    Navigator.pop(context,{'name':_categoryNameController.text,'color':_selectedColor,'icon':_selectedIcon});
  }

  @override
  void initState(){
    _categoryNameController.text=widget.initialTitle??'';
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    _categoryNameController.dispose();
  }

  bool _isSelectingIcon=false;

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      backgroundColor:Colors.white,
      shape:RoundedRectangleBorder(
        borderRadius:BorderRadius.zero,
      ),
      title:Text(widget.title),
      content:SizedBox(
        width:double.maxFinite,
        child:Column(
          mainAxisSize:MainAxisSize.min,
          mainAxisAlignment:MainAxisAlignment.center,
          children:[
            Row(
              spacing:8,
              children:[
                Transform.scale(
                  scale:0.8,
                  child:IconButton(
                    padding:EdgeInsets.zero,
                    icon:_selectedIcon!=null
                      ?Icon(iconMap[_selectedIcon],size:48)
                      :Stack(
                        clipBehavior:Clip.none,
                        children:[
                          Icon(
                            Icons.emoji_emotions,
                            size:48,
                            color:_selectedColor,
                          ),
                          Positioned(
                            top:0,
                            left:0,
                            child:Icon(
                              Icons.add_circle,
                              size:22,
                              color:_selectedColor,
                            ),
                          ),
                        ],
                      ),
                    onPressed:()=>setState(()=>_isSelectingIcon=!_isSelectingIcon),
                  ),
                ),
                Expanded(
                  child:TextField(
                    controller:_categoryNameController,
                    decoration:InputDecoration(
                      hintText:'Nome da categoria',
                      enabledBorder:UnderlineInputBorder(
                        borderSide:BorderSide(color:_selectedColor,width:2),
                      ),
                      focusedBorder:UnderlineInputBorder(
                        borderSide:BorderSide(color:_selectedColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height:20),
            if(_isSelectingIcon)
              ConstrainedBox(
                constraints:BoxConstraints(maxHeight:200),
                child:GridView.builder(
                  shrinkWrap:true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:6,
                    mainAxisSpacing:12,
                    crossAxisSpacing:12,
                    childAspectRatio:1,
                  ),
                  itemCount:18, // 6 columns × 3 rows
                  itemBuilder:(context,index){
                    IconData theIcon=iconMap.values.toList()[index];
                    String theIconName=iconMap.keys.toList()[index];
                    return GestureDetector(
                      onTap:()=>setState(()=>_selectedIcon=theIconName),
                      child:Icon(
                        theIcon,
                        size:32,
                      ),
                    );
                  },
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection:Axis.horizontal,
                child:Row(
                  spacing:16,
                  children:colors.map((color)=>
                    GestureDetector(
                      onTap:()=>setState(()=>_selectedColor=color),
                      child:
                        SizedBox(
                          width:35,
                          height:35,
                          child:Stack(
                            alignment:Alignment.center,
                            children:[
                              Container(
                                width:35,
                                height:35,
                                decoration: BoxDecoration(
                                  color:color,
                                  shape:BoxShape.circle,
                                ),
                              ),
                              if(color==_selectedColor)
                                Container(
                                  width:7,
                                  height:7,
                                  decoration:BoxDecoration(
                                    color:Colors.white,
                                    shape:BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                    )
                  ).toList(),
                ),
              ),
          ],
        ),
      ),
      actions:[
        TextButton(
          onPressed:()=>Navigator.of(context).pop(),
          child:Text('CANCELAR'),
        ),
        TextButton(
          onPressed:()=>_createCategory(context),
          child:Text(widget.confirmationButtonText),
        ),
      ],
    );
  }
}
