const {Op}=require('sequelize');
const User=require('../models/user');
const Category=require('../models/category');
const CategoryNormal=require('../models/category_normal');
const CategoryPeriodic=require('../models/category_periodic');
const Todo=require('../models/todo');
const {generateAccessToken}=require('../utils/jwt');

const login=async(req,res)=>{
  const {email,password}=req.body;
  const user=await User.findOne({where:{email,password}});

  if(!user)return res
    .status(401)
    .json({error:'Email and password do not match'});

  const accessToken=generateAccessToken(user.id);

  res.json({accessToken});
};

// Return Info of Authenticated User
const getMe=async(req,res)=>{
  const userId=req.userId;
  const user=await User.findByPk(userId,{attributes:['id','name','email','is_dark_mode_preferred']});

  if(!user)
    return res
      .status(404)
      .json({error:'User Not Found'});

  return res.json(user);
};

const getAllCategories=async(req,res)=>{
  try{
    const userId=req.userId;
    const categories=await Category.findAll({
      where:{'user_id':userId}
    });

    return res.json(categories);
  }catch(err){
    return res.status(500).json({error:err.message});
  }
};

const createCategory=async(req,res)=>{
  try{
    const userId=req.userId;
    const {name,color,icon,type}=req.body;
    const {due_date}=req.body;
    const {repeat_interval_days,automatic_mode}=req.body;

    const types=['normal','periodic'];
    if(!types.includes(type))return res.status(400).json({message:'type not in (normal,periodic)'});

    const category=await Category.create({
      name,
      color,
      icon,
      type,
      user_id:userId,
    });

    let specialization;
    switch(type){
      case 'normal':
        console.log('normal');
        specialization=await CategoryNormal.create({id:category.id,due_date});
        return res.json({
          ...category.toJSON(),
          specialization:{
            due_date:specialization.due_date,
          },
        });
      case 'periodic':
        console.log('periodic');
        specialization=await CategoryPeriodic.create({id:category.id,repeat_interval_days,automatic_mode});
        return res.json({
          ...category.toJSON(),
          specialization:{
            repeat_interval_days,
            automatic_mode,
          },
        });
    }
  }catch(err){
    return res.status(500).json({error:err.message});
  }
};

const getTodosByCategoryId=async(req,res)=>{
  try{
    const categoryId=req.params.category_id;
    const todos=await Todo.findAll({where:{category_id:categoryId}});

    return res.json(todos);
  }catch(err){
    return res.status(500).json({error:err.message});
  }
};

const createTodo=async(req,res)=>{
  try{
    const userId=req.userId;
    const {title,is_done=false,due_date}=req.body;
    const categoryId=req.params.category_id;

    const todo=await Todo.create({
      title,
      is_done,
      'due_date':due_date,
      'category_id':categoryId,
      'user_id':userId,
    });

    return res.json(todo);
  }catch(err){
    return res.status(500).json({error:err.message});
  }
};

const getAllTodos=async(req,res)=>{
  const userId=req.userId;
  const {filter,date,isComplete}=req.query;

  const where={user_id:userId};

  const today=new Date();

  if(filter==='today'){
    where.due_date=today.toISOString().split('T')[0];
  }else if(filter==='thisWeek'){
    const startOfWeek=new Date(today);
    startOfWeek.setDate(today.getDate()-today.getDay());

    const endOfWeek=new Date(startOfWeek);
    endOfWeek.setDate(startOfWeek.getDate()+7);

    where.due_date={
      [Op.gte]:startOfWeek,
      [Op.lt]:endOfWeek,
    };
  }else if(filter=='overdue'){
    where.due_date={[Op.lt]:today};
  }

  if(isComplete!==undefined)where.is_done=isComplete==='true';

  if(date)where.dueDate=date;

  const todos=await Todo.findAll({
    where,
    include:{
      model:Category,
      attributes:['id','name','color','type'],
      as:'category',
    },
  });

  return res.json(todos);
};

const getTodoById=async(req,res)=>{
  try{
    const userId=req.userId;
    const todoId=req.params.todo_id;
    const todo=await Todo.findOne({where:{id:todoId,user_id:userId}});

    if(!todo)return res.status(404).json({error:'Todo not found'});

    return res.json(todo);
  }catch(err){
    return res.status(500).json({error:err.message});
  }
};

const deleteTodoById=async(req,res)=>{
  try{
    const userId=req.userId;
    const todoId=req.params.todo_id;
    const affectedRows=await Todo.destroy({where:{id:todoId,user_id:userId}});

    if(affectedRows===0)return res.status(404).json({error:'Todo not found'});

    return res.json({message:'Todo successfully deleted'});
  }catch(err){
    return res.status(500).json({error:err.message});
  }
};

const updateTodo=async(req,res)=>{
  try{
    const userId=req.userId;
    const todoId=req.params.todo_id;
    const {is_done,title,due_date}=req.body;

    const todo=await Todo.findOne({where:{id:todoId,user_id:userId}});

    if(!todo)return res.status(404).json({message:'Todo not found'});

    if(is_done!==undefined){
      todo.is_done=is_done;
      todo.completed_at=is_done?new Date():null;
    }
    if(title!==undefined)todo.title=title;
    if(due_date!==undefined)todo.due_date=due_date;

    await todo.save();

    return res.json(todo);
  }catch(err){
    return res.status(500).json({error:err.message});
  }
};

const deleteTodos=async(req,res)=>{
  try{
    const userId=req.userId;
    const todosId=req.body.todosId;

    await Todo.destroy({where:{id:todosId,user_id:userId}});

    return res.json({message:'Todos successfully deleted'});
  }catch(err){
    return res.status(500).json({error:err.message});
  }
};

const getCategoryById=async(req,res)=>{
  try{
    const userId=req.userId;
    const categoryId=req.params.category_id;

    const category=await Category.findOne({where:{id:categoryId,user_id:userId}});

    if(!category)return res.status(404).json({error:'Category not found'});

    return res.json(category);
  }catch(err){
    return res.status(500).json({error:err.message});
  }
};

const deleteCategoryById=async(req,res)=>{
  try{
    const userId=req.userId;
    const categoryId=req.params.category_id;

    const affectedRows=await Category.destroy({where:{id:categoryId,user_id:userId}});

    if(affectedRows===0)return res.status(404).json({error:'Category not found'});

    return res.json({message:'Category successfully deleted'});
  }catch(err){
    return res.status(500).json({error:err.message});
  }
};

const updateCategory=async(req,res)=>{
  try{
    const userId=req.userId;
    const categoryId=req.params.category_id;

    const category=await Category.findOne({where:{id:categoryId,user_id:userId}});

    if(!category)return res.status(404).json({error:'Category not found'});

    category.update(req.body);

    return res.json(category);
  }catch(err){
    return res.status(500).json({error:err.message});
  }
};

const toggleTheme=async(req,res)=>{
  try{
    const userId=req.userId;
    const {is_dark_mode_preferred}=req.body;

    const user=await User.findByPk(userId);
    if(!user)return res.status(404).json({error:'User not found'});

    user['is_dark_mode_preferred']=is_dark_mode_preferred;
    await user.save();

    return res.json({message:'Theme successfully updated'});
  } catch(err){
    return res.status(500).json({error:err.message});
  }
}

module.exports={
  login,
  getMe,
  toggleTheme,
  getAllCategories,
  createCategory,
  getCategoryById,
  deleteCategoryById,
  getAllTodos,
  getTodosByCategoryId,
  createTodo,
  deleteTodoById,
  updateTodo,
  deleteTodos,
  updateCategory,
  getTodoById,
};
