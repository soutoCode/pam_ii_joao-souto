import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ristretto/core/models/login_form_data.dart';
import 'package:ristretto/core/services/user.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState()=>_LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final LoginFormData _loginFormData=LoginFormData();
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  bool showErrorFlag=false;
  bool processingRequestFlag=false;

  Future<void> _onSubmit(BuildContext context)async{
    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();

    try{
      setState((){
        showErrorFlag=false;
        processingRequestFlag=true;
      });

      await Future.delayed(Duration(seconds:1));

      await UserService.instance.login(
        email:_loginFormData.email,
        password:_loginFormData.password,
      );

      context.go('/user');
    }on DioException catch(err){
      setState((){
        showErrorFlag=true;
        processingRequestFlag=false;
      });
    }
  }

  TextFormField _buildEmailInput(){
    return TextFormField(
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
      onSaved:(value)=>_loginFormData.email=value!,
    );
  }

  TextFormField _buildPasswordInput(){
    return TextFormField(
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
      textInputAction:TextInputAction.done,
      style: const TextStyle(color: Colors.black87),
      onSaved:(value)=>_loginFormData.password=value!,
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
        ?Text('Entrar',style:TextStyle(fontWeight:FontWeight.w700,fontSize:20))
        :SizedBox(
          width:18,
          height:18,
          child:CircularProgressIndicator(),
        ),
    );
  }

  TextButton _buildGoogleLoginButton(){
    return TextButton.icon(
      onPressed:(){},
      icon:Icon(FontAwesomeIcons.google),
      style:FilledButton.styleFrom(
        side:BorderSide(color:Colors.grey),
        shape: RoundedRectangleBorder(
          borderRadius:BorderRadius.circular(8),
        ),
      ),
      label:Text('Google',style:TextStyle(fontWeight:FontWeight.w500,fontSize:16)),
    );
  }

  TextButton _buildAppleLoginButton(){
    return TextButton.icon(
      onPressed:(){},
      icon:Icon(FontAwesomeIcons.apple),
      style:FilledButton.styleFrom(
        side:BorderSide(color:Colors.grey),
        shape: RoundedRectangleBorder(
          borderRadius:BorderRadius.circular(8),
        ),
      ),
      label:Text('Apple ID',style:TextStyle(fontWeight:FontWeight.w500,fontSize:16)),
    );
  }

  Text _buildFooter(BuildContext context){
    return Text.rich(
      style:TextStyle(fontSize:16,fontWeight:FontWeight.w600),
      TextSpan(
        text:'Não possui uma conta? ',
        children:[
          TextSpan(
            text:'Cadastre-se',
            style:TextStyle(color:Color(0xFF80AEFF)),
            recognizer:TapGestureRecognizer()
              ..onTap=()=>context.go('/register/step-1'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset:true,
      body:SingleChildScrollView(
       padding:EdgeInsets.symmetric(horizontal:24),
        child: ConstrainedBox(
          constraints:BoxConstraints(minHeight:MediaQuery.of(context).size.height),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.stretch,
              mainAxisAlignment:MainAxisAlignment.center,
              children:[
                Text(
                  'Bem-vindo\nde volta!',
                  style:TextStyle(
                    fontWeight:FontWeight.w800,
                    fontSize:40,
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
                    ],
                  ),
                ),
                SizedBox(height:8),
                Align(
                  alignment:Alignment.centerRight,
                  child:Text(
                    'Esqueceu a senha?',
                    style:TextStyle(
                      fontSize:16,
                      fontWeight:FontWeight.w600,
                      color:Color(0xFF80AEFF),
                    ),
                  ),
                ),
                SizedBox(height:16),
                if(showErrorFlag)...[
                  Text(
                    'E-mail ou senha incorretos',
                    textAlign:TextAlign.center,
                    style:TextStyle(
                      fontSize:16,
                      color:Colors.red,
                    ),
                  ),
                  SizedBox(height:16),
                ],
                _buildSubmitButton(context),
                SizedBox(height:16),
                Align(
                  alignment:Alignment.center,
                  child:Text(
                    'Ou entrar com',
                    style:TextStyle(
                      color:Colors.grey,
                      fontSize:16,
                    ),
                  ),
                ),
                SizedBox(height:16),
                _buildGoogleLoginButton(),
                SizedBox(height:16),
                _buildAppleLoginButton(),
                SizedBox(height:16),
                Align(
                  alignment:Alignment.center,
                  child:_buildFooter(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
