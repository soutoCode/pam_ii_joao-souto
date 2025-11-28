import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ristretto/core/models/register_form_data.dart';
import 'package:ristretto/core/services/user.dart';

class RegisterStep2Screen extends StatefulWidget{
  final RegisterFormData? persist;

  const RegisterStep2Screen(this.persist,{super.key});

  @override
  State<RegisterStep2Screen> createState()=>_RegisterStep2ScreenState();
}

class _RegisterStep2ScreenState extends State<RegisterStep2Screen>{
  late final RegisterFormData _registerFormData;
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  bool processingRequestFlag=false;
  Map<String,String> _errors={};

  @override
  void initState(){
    super.initState();
    _registerFormData=widget.persist??RegisterFormData();
  }

  void _onSubmit(BuildContext context)async{
    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();

    setState((){
      _errors={};
      processingRequestFlag=true;
    });

    await Future.delayed(Duration(seconds:1));

    final Map<String,String> result=await UserService.instance.registerStep2(
      name:_registerFormData.name,
    );

    if(result.isEmpty){
      context.go('/login');
      return;
    }

    debugPrint(result.toString());

    setState((){
      _errors=result;
      processingRequestFlag=false;
    });
  }

  Column _buildNameInput(){
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      children:[
        TextFormField(
          textAlign:TextAlign.center,
          decoration:InputDecoration(
            filled:true,
            fillColor:const Color(0xFFF0F0F0),
            hintText:'Insira seu nome',
            hintStyle:const TextStyle(color:Colors.grey),
            border:OutlineInputBorder(
              borderRadius:BorderRadius.circular(8),
              borderSide:BorderSide.none,
            ),
            contentPadding:const EdgeInsets.symmetric(vertical:14,horizontal:16),
          ),
          style:const TextStyle(color: Colors.black87),
          initialValue:_registerFormData.name,
          onSaved:(value)=>_registerFormData.name=value!,
        ),
        if(_errors.containsKey('name'))...[
          SizedBox(height:4),
          Text(
            _errors['name']!,
            style:TextStyle(fontSize:16,color:Colors.red),
          ),
        ],
      ],
    );
  }

  FilledButton _buildSubmitButton(BuildContext context){
    return FilledButton(
      onPressed:processingRequestFlag?null:()=>_onSubmit(context),
      style:FilledButton.styleFrom(
        backgroundColor:Color(0xFF80AEFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBackgroundColor:Color(0xFFA5C6FF),
      ),
      child:!processingRequestFlag
        ?Text('Finalizar cadastro',style:TextStyle(fontWeight:FontWeight.w700,fontSize:20))
        :SizedBox(
          width:18,
          height:18,
          child:CircularProgressIndicator(),
        ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset:true,
      appBar:AppBar(
        leading:IconButton(
          onPressed:()=>context.go('/register/step-1',extra:_registerFormData),
          icon:Icon(Icons.chevron_left,size:40),
        ),
      ),
      body:SingleChildScrollView(
        padding:EdgeInsets.symmetric(horizontal:24),
        child: ConstrainedBox(
          constraints:BoxConstraints(minHeight:MediaQuery.of(context).size.height),
          child:IntrinsicHeight(
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.stretch,
              children:[
                Align(
                  alignment:AlignmentDirectional.center,
                  child:Text(
                    'Personalize seu perfil',
                    textAlign:TextAlign.center,
                    style:TextStyle(
                      fontWeight:FontWeight.w800,
                      fontSize:40,
                    ),
                  ),
                ),
                SizedBox(height:40),
                Form(
                  key:_formKey,
                  child:Column(
                    children:[
                      Text(
                        'Como gostaria de ser chamado?',
                        style:TextStyle(fontSize:20,fontWeight:FontWeight.w500),
                      ),
                      SizedBox(height:12),
                      _buildNameInput(),
                    ],
                  ),
                ),
                SizedBox(height:40),
                _buildSubmitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
