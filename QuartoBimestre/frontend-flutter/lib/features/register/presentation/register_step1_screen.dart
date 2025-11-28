import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ristretto/core/models/register_form_data.dart';
import 'package:ristretto/core/services/user.dart';

class RegisterStep1Screen extends StatefulWidget{
  final RegisterFormData? persist;

  const RegisterStep1Screen(this.persist,{super.key});

  @override
  State<RegisterStep1Screen> createState()=>_RegisterStep1ScreenState();
}

class _RegisterStep1ScreenState extends State<RegisterStep1Screen>{
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

    debugPrint('GUYS1');
    final Map<String,String> result=await UserService.instance.registerStep1(
      email:_registerFormData.email,
      password:_registerFormData.password,
      confirmPassword:_registerFormData.confirmPassword,
    );
    debugPrint('GUYS2');

    if(result.isEmpty){
      context.go('/register/step-2',extra:_registerFormData);
      return;
    }

    setState((){
      _errors=result;
      processingRequestFlag=false;
    });
  }

  Column _buildEmailInput(){
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      children:[
        TextFormField(
          decoration:InputDecoration(
            filled:true,
            fillColor:const Color(0xFFF0F0F0),
            prefixIcon:const Icon(Icons.email_outlined,color:Colors.grey),
            hintText:'E-mail',
            hintStyle:const TextStyle(color:Colors.grey),
            border:OutlineInputBorder(
              borderRadius:BorderRadius.circular(8),
              borderSide:BorderSide.none,
            ),
            contentPadding:const EdgeInsets.symmetric(vertical:14,horizontal:16),
          ),
          textInputAction:TextInputAction.next,
          style:const TextStyle(color: Colors.black87),
          initialValue:_registerFormData.email,
          onSaved:(value)=>_registerFormData.email=value!,
        ),
        if(_errors.containsKey('email'))...[
          SizedBox(height:4),
          Text(
            _errors['email']!,
            style:TextStyle(fontSize:16,color:Colors.red),
          ),
        ]
      ],
    );
  }

  Column _buildPasswordInput(){
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      children:[
        TextFormField(
          obscureText:true,
          decoration: InputDecoration(
            filled:true,
            fillColor:const Color(0xFFF0F0F0),
            prefixIcon:const Icon(Icons.lock,color:Colors.grey),
            hintText:'Senha',
            hintStyle:const TextStyle(color:Colors.grey),
            border:OutlineInputBorder(
              borderRadius:BorderRadius.circular(8),
              borderSide:BorderSide.none,
            ),
            contentPadding:const EdgeInsets.symmetric(vertical:14,horizontal:16),
          ),
          textInputAction:TextInputAction.next,
          style: const TextStyle(color: Colors.black87),
          initialValue:_registerFormData.password,
          onSaved:(value)=>_registerFormData.password=value!,
        ),
        if(_errors.containsKey('password'))...[
          SizedBox(height:4),
          Text(
            _errors['password']!,
            style:TextStyle(fontSize:16,color:Colors.red),
          ),
        ]
      ],
    );
  }

  Column _buildConfirmPasswordInput(){
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      children:[
        TextFormField(
          obscureText:true,
          decoration: InputDecoration(
            filled:true,
            fillColor:const Color(0xFFF0F0F0),
            prefixIcon:const Icon(Icons.lock,color:Colors.grey),
            hintText:'Confirmar Senha',
            hintStyle:const TextStyle(color:Colors.grey),
            border:OutlineInputBorder(
              borderRadius:BorderRadius.circular(8),
              borderSide:BorderSide.none,
            ),
            contentPadding:const EdgeInsets.symmetric(vertical:14,horizontal:16),
          ),
          textInputAction:TextInputAction.done,
          style: const TextStyle(color: Colors.black87),
          initialValue:_registerFormData.confirmPassword,
          onSaved:(value)=>_registerFormData.confirmPassword=value!,
        ),
        if(_errors.containsKey('confirmPassword'))...[
          SizedBox(height:4),
          Text(
            _errors['confirmPassword']!,
            style:TextStyle(fontSize:16,color:Colors.red),
          ),
        ]
      ],
    );
  }

  GestureDetector _buildRedirectLogin(BuildContext context){
    return GestureDetector(
      onTap:()=>context.go('/login'),
      child:Text(
        'Já possui uma conta?',
        style:TextStyle(
          fontSize:16,
          fontWeight:FontWeight.w600,
          color:Color(0xFF80AEFF),
        ),
      ),
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
        ?Text('Próximo',style:TextStyle(fontWeight:FontWeight.w700,fontSize:20))
        :SizedBox(
          width:18,
          height:18,
          child:CircularProgressIndicator(),
        ),
    );
  }

  TextButton _buildRegisterGoogleButton(){
    return TextButton.icon(
      onPressed:(){},
      icon:Icon(FontAwesomeIcons.google),
      style:FilledButton.styleFrom(
        side:BorderSide(color:Colors.grey),
        shape: RoundedRectangleBorder(
          borderRadius:BorderRadius.circular(8),
        ),
        padding:const EdgeInsets.all(12),
      ),
      label:Text('Google',style:TextStyle(fontWeight:FontWeight.w500,fontSize:16)),
    );
  }

  TextButton _buildRegisterAppleButton(){
    return TextButton.icon(
      onPressed:(){},
      icon:Icon(FontAwesomeIcons.apple),
      style:FilledButton.styleFrom(
        side:BorderSide(color:Colors.grey),
        shape: RoundedRectangleBorder(
          borderRadius:BorderRadius.circular(8),
        ),
        padding:const EdgeInsets.all(12),
      ),
      label:Text('Apple ID',style:TextStyle(fontWeight:FontWeight.w500,fontSize:16)),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset:true,
      body:SingleChildScrollView(
        padding:EdgeInsets.symmetric(horizontal:24),
        child:ConstrainedBox(
          constraints:BoxConstraints(minHeight:MediaQuery.of(context).size.height),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.stretch,
              mainAxisAlignment:MainAxisAlignment.center,
              children:[
                Align(
                  alignment:AlignmentDirectional.center,
                  child:Text(
                    'Vamos Começar!',
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
                      _buildEmailInput(),
                      SizedBox(height:16),
                      _buildPasswordInput(),
                      SizedBox(height:16),
                      _buildConfirmPasswordInput(),
                    ],
                  ),
                ),
                SizedBox(height:8),
                Align(
                  alignment:Alignment.center,
                  child:_buildRedirectLogin(context),
                ),
                SizedBox(height:16),
                _buildSubmitButton(context),
                SizedBox(height:48),
                Align(
                  alignment:Alignment.center,
                  child:Text('Ou continue com',style:TextStyle(color:Colors.grey,fontSize:16)),
                ),
                SizedBox(height:16),
                _buildRegisterGoogleButton(),
                SizedBox(height:16),
                _buildRegisterAppleButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
