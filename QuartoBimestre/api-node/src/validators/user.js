const User = require("../models/user");

function validateName(name){
  const result={isValid:true,message:''};
  const nameRegex=/^[a-zA-Z\s'-]{3,50}$/;

  if(!name||name==='')result.message='Nome não pode ser vazio';
  else if(!nameRegex.test(name))
    result.message='Nome deve conter pelo menos 3 caractéres e apenas letras e espaços';

  if(result.message!=='')result.isValid=false;

  return result;
}

async function doesEmailExist(email){
  const user=await User.findOne({where:{email}});

  return user!==null;
}

async function validateEmail(email){
  const result={isValid:true,message:''};
  const emailRegex=/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

  if(!email||email==='')result.message='Email não pode ser vazio';
  else if(!emailRegex.test(email))result.message='Email é inválido';
  else if(await doesEmailExist(email))result.message='Email já está em uso';

  if(result.message!=='')result.isValid=false;

  return result;
}

function validatePassword(password){
  const result={isValid:true,message:''};
  const passwordRegex=/^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[^A-Za-z0-9]).{8,}$/;

  if(!password||password==='')result.message='Senha não pode ser vazia';
  else if(!passwordRegex.test(password))
    result.message='A senha deve conter pelo menos 8 caracteres, incluindo letras maiúsculas, minúsculas, números e caracteres especiais';

  if(result.message!=='')result.isValid=false;

  return result;
}

async function validateRegisterUser(name,email,password){
  const errors={};
  let temp;

  temp=validateName(name);
  if(!temp.isValid)errors['name']=temp.message;

  temp=await validateEmail(email);
  if(!temp.isValid)errors['email']=temp.message;

  temp=validatePassword(password);
  if(!temp.isValid)errors['password']=temp.message;

  return errors;
}

module.exports={
  validateName,
  validateEmail,
  validatePassword,
  validateRegisterUser,
};
