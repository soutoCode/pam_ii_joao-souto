import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ristretto/core/enums/theme.dart';
import 'package:ristretto/core/models/iuser.dart';
import 'package:ristretto/core/routes/main_app.dart';
import 'package:ristretto/core/services/user.dart';
import 'package:ristretto/core/themes/colors.dart';
import 'package:ristretto/features/user/presentation/user_section.dart';

class UserScreen extends StatefulWidget{
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>{
  bool _isLoading=true;
  late IUser _user;
  late TheTheme _selectedTheme;

  Future<void> _initializeData()async{
    await Future.delayed(Duration(seconds:1));

    final IUser user=await UserService.instance.getMe();

    _selectedTheme=user.isDarkModePreferred?TheTheme.dark:TheTheme.light;

    setState((){
      _isLoading=false;
      _user=user;
    });
  }

  @override
  void initState(){
    super.initState();
    _initializeData();
  }

  Container _buildWelcomeUser(BuildContext context){
    return Container(
      padding:const EdgeInsets.all(24),
      child:Column(
        children:[
          Text(
            'Bom dia!',
            style:Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            _user.name,
            style:Theme.of(context).textTheme.headlineLarge,
          ),
        ],
      ),
    );
  }

  Container _buildAchievement(BuildContext context){
    return Container(
      padding:const EdgeInsets.all(12),
      decoration:BoxDecoration(
        color:Color(0xFFA1C3FF),
        borderRadius:BorderRadius.circular(8),
      ),
      child:Row(
        spacing:8,
        children: [
          Container(
            padding:EdgeInsets.all(16),
            decoration:BoxDecoration(
              color:Color(0XFFC8E1FF),
              shape:BoxShape.circle,
            ),
            child: Icon(Icons.shopping_cart),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                Text(
                  'Uma caixa de leite',
                  style:Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight:FontWeight.w600,
                  ),
                ),
                Text(
                  '${_user.name}, seu progresso está indo bem!',
                  style:Theme.of(context).textTheme.headlineSmall,
                  softWrap:true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  UserSection _buildStats(BuildContext context){
    return UserSection(
      title:'Estatísticas',
      child: SingleChildScrollView(
          scrollDirection:Axis.horizontal,
          child:Row(
            spacing:12,
            children:[
              // Show Total Complete Todos
              Container(
                padding:const EdgeInsets.all(12),
                decoration:BoxDecoration(
                  color:Color(0XFFFFE5C8),
                  borderRadius:BorderRadius.circular(8),
                ),
                child:Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children:[
                    Text('Tarefas concluídas',style:Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight:FontWeight.w600,
                    )),
                    Text('19',style:Theme.of(context).textTheme.displayLarge),
                  ],
                ),
              ),
              // Show Percentage
              Container(
                padding:const EdgeInsets.all(12),
                decoration:BoxDecoration(
                  color:Color(0xFFEFBEB3),
                  borderRadius:BorderRadius.circular(8),
                ),
                child:Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children:[
                    Text('Rotina',style:Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight:FontWeight.w600,
                    )),
                    Text('88%',style:Theme.of(context).textTheme.displayLarge),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

  UserSection _buildReport(){
    return UserSection(
      title:'Relatório',
      child:Container(
        height:140,
        decoration:BoxDecoration(
          color:AppColors.primaryColor,
          borderRadius:BorderRadius.circular(8),
        ),
      ),
    );
  }

  UserSection _buildStreak(BuildContext context){
    return UserSection(
      title:'Sequência',
      child:Row(
        spacing:8,
        children:[
          Icon(Icons.flag),
          Expanded(
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children:[
                Text('17 Dias',style:Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontSize:20,
                )),
                Text('de atividade',style:Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight:FontWeight.bold,
                )),
              ],
            ),
          ),
          Icon(Icons.remove_red_eye_outlined),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return 
      MainApp(
        child: _isLoading
          ?Center(child:CircularProgressIndicator())
          :Stack(
            children:[
              SizedBox(
                width:double.infinity,
                height:450,
                child:Image.asset('assets/images/background.png',fit:BoxFit.cover),
              ),
              Positioned(
                right:16,
                top:16,
                child:IconButton(
                  onPressed:()=>context.push('/user/settings',extra:{'theme':_selectedTheme}),
                  icon:Icon(Icons.settings),
                ),
              ),
              Column(
                children:[
                  _buildWelcomeUser(context),
                  Expanded(
                    flex:1,
                    child: Container(
                      padding:const EdgeInsets.all(16),
                      margin:const EdgeInsets.symmetric(horizontal:16),
                      decoration:BoxDecoration(
                        color:Colors.white,
                        borderRadius:BorderRadius.only(
                          topLeft:Radius.circular(8),
                          topRight:Radius.circular(8),
                        ),
                        border:BoxBorder.all(
                          color:Color(0XFFD9D9D9),
                          width:2,
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment:CrossAxisAlignment.start,
                          spacing:12,
                          children:[
                            _buildAchievement(context),
                            _buildStats(context),
                            _buildReport(),
                            _buildStreak(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]
          ),
      );
  }







//   @override
//   Widget build(BuildContext context){
//     return Stack(
//       children:[
//         MainApp(
//           child:_isLoading
//             ?Center(child:CircularProgressIndicator())
//             :Column(
//               crossAxisAlignment:CrossAxisAlignment.stretch,
//               children:[
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment:CrossAxisAlignment.start,
//                     children:[
//                       Text(_user.name,style:TextStyle(fontSize:28,fontWeight:FontWeight.bold)),
//                       Text(_user.email,style:TextStyle(fontSize:16,fontWeight:FontWeight.bold)),
//                     ],
//                   ),
//                 ),
//                 Divider(color:Colors.grey,thickness:1),
//                 PopupMenuButton(
//                   child:Padding(
//                     padding: const EdgeInsets.symmetric(vertical:16,horizontal:16),
//                     child: Column(
//                       crossAxisAlignment:CrossAxisAlignment.start,
//                       children:[
//                         Text('Tema',style:TextStyle(fontSize:18)),
//                         Text(_selectedTheme.label,style:TextStyle(color:Colors.blueGrey,fontSize:16)),
//                       ],
//                     ),
//                   ),
//                   onSelected:_toggleTheme,
//                   itemBuilder:(context)=>[
//                     PopupMenuItem(value:TheTheme.dark,child:Text('Tema escuro')),
//                     PopupMenuItem(value:TheTheme.light,child:Text('Tema claro')),
//                   ],
//                 ),
//                 TextButton(
//                   style:TextButton.styleFrom(
//                     padding:const EdgeInsets.symmetric(vertical:16,horizontal:16),
//                     shape:const RoundedRectangleBorder(
//                       borderRadius:BorderRadius.zero,
//                     ),
//                     alignment:Alignment.topLeft
//                   ),
//                   onPressed:_logout,
//                   child:Text(
//                     'ENCERRAR SESSÃO',
//                     style:TextStyle(fontWeight:FontWeight.bold,color:Colors.red),
//                   ),
//                 ),
//               ],
//             )
//         ),
//         if(_processingRequest)
//           Positioned.fill(
//             child:Container(
//               color:Colors.black.withValues(alpha:0.5),
//               child:Center(
//                 child:CircularProgressIndicator(),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
}
