const User=require('../models/user');
const {validateRegisterUser}=require('../validators/user');

const getAllUsers=async(req,res)=>{
  try{
    const users=await User.findAll();
    return res.json(users);
  }catch(err){
    res.status(500).json({error:err.message});
  }
};

const getUserById=async(req,res)=>{
  try{
    const userId=req.params.user_id;
    const user=await User.findByPk(userId);

    if(!user)return res.status(404).json({error:'User not found'});

    return res.json(user);
  }catch(err){
    res.status(500).json({error:err.message});
  }
};

const createUser=async(req,res)=>{
  try{
    const {name,email,password}=req.body;
    const errors=await validateRegisterUser(name,email,password);

    // Check whether User Data is valid
    if(Object.keys(errors).length>0)return res.status(400).json(errors);

    const user=await User.create({name,email,password});

    res.status(201).json(user);
  }catch(err){
    res.status(500).json({error:err.message});
  }
}    

const deleteUserById=async(req,res)=>{
  try{
    const userId=req.params.user_id;
    const affectedRows=await User.destroy({where:{id:userId}});

    if(affectedRows===0)return res.status(404).json({error:'User not found'});

    return res.json({message:'User successfully deleted'});
  }catch(err){
    return res.status(500).json({error:err.mesage});
  }
}

module.exports={
  createUser,
  getAllUsers,
  getUserById,
  deleteUserById,
};
