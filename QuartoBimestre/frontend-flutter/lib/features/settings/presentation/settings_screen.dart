import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ristretto/core/enums/theme.dart';
import 'package:ristretto/core/services/auth.dart';
import 'package:ristretto/core/services/user.dart';

class SettingsScreen extends StatefulWidget{
  final TheTheme theme;

  SettingsScreen({super.key,required this.theme});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>{
  bool _processingRequest=false;
  TheTheme _selectedTheme=TheTheme.light;

  void initState(){
    super.initState();
    _selectedTheme=widget.theme;
    debugPrint(_selectedTheme.label);
  }

  Future<void> _toggleTheme(TheTheme value)async{
    setState(()=>_processingRequest=true);
    await Future.delayed(Duration(seconds:1));
    await UserService.instance.toggleTheme(value);
    setState((){
      _selectedTheme=value;
      _processingRequest=false;
    });
  }

  void _logout(BuildContext context)async{
    setState(()=>_processingRequest=true);
    await AuthService.instance.logout();
    context.go('/login');
    setState(()=>_processingRequest=false);
  }

  @override
  Widget build(BuildContext context){
    return Stack(
      children: [
        Scaffold(
          appBar:AppBar(
            leading:IconButton(
              onPressed:()=>Navigator.pop(context),
              icon:Icon(Icons.chevron_left),
            ),
            title:Text('Configurações'),
          ),
          body:Column(
            children:[
              ListTile(
                leading:PopupMenuButton(
                  onSelected:_toggleTheme,
                  itemBuilder:(context)=>[
                    PopupMenuItem(value:TheTheme.dark,child:Text('Tema escuro')),
                    PopupMenuItem(value:TheTheme.light,child:Text('Tema claro')),
                  ],
                  child:Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children:[
                      Text('TEMA',style:TextStyle(fontSize:16,fontWeight:FontWeight.w600)),
                      Text(_selectedTheme.label,style:TextStyle(color:Colors.blueGrey,fontSize:16)),
                    ],
                  ),
                ),
              ),
              ListTile(
                onTap:()=>_logout(context),
                title:Text(
                  'ENCERRAR SESSÃO',
                  style:TextStyle(fontSize:16,fontWeight:FontWeight.w600,color:Colors.red),
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
