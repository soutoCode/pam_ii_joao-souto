const {validateEmail, validatePassword, validateName} = require('../validators/user');
const {redis}=require('../config/redis');
const {randomUUID}=require('crypto');
const User = require('../models/user');

const registerUserStep1=async(req,res)=>{
  const {email,password,confirmPassword}=req.body;
  console.log('fuck');

  const errors={};
  let temp;

  // Validate email
  temp=await validateEmail(email);
  if(!temp.isValid)errors['email']=temp.message;

  // Validate password
  temp=validatePassword(password);
  if(!temp.isValid)errors['password']=temp.message;

  if(temp.isValid&&confirmPassword!==password)
    errors['confirmPassword']='Senha e confirmação de senha precisam ser iguais';

  if(Object.keys(errors).length>0)return res.status(400).json(errors);

  // REDIS!!!
  const registrationToken=randomUUID();
  await redis.set(
    `register:${registrationToken}`,
    JSON.stringify({email,password}),
    {expiration:{
      type:"EX",
      value:60*60,
    }},
  );

  return res.json({step:2,registrationToken});
};

const registerUserStep2=async(req,res)=>{
  const {name}=req.body;

  const errors={};
  let temp;

  // Validate name
  temp=validateName(name);
  if(!temp.isValid)errors['name']=temp.message;

  console.log(temp.isValid);
  if(Object.keys(errors).length>0)return res.status(400).json(errors);

  const registrationToken=req.headers['registration-token'];
  if(!registrationToken)return res.status(400).json({message:'missing registration token header'});

  const previousStepRawData=await redis.get(`register:${registrationToken}`);
  if(previousStepRawData===null)return res.status(404).json({message:'registration token expired'});

  const previousStepData=JSON.parse(previousStepRawData);
  const {email,password}=previousStepData;

  const finalUser={
    name,
    email,
    password,
  };

  await User.create(finalUser);

  await redis.del(`registration:${registrationToken}`);

  return res.json({message:'user successfully created'});
};

module.exports={
  registerUserStep1,
  registerUserStep2,
};
