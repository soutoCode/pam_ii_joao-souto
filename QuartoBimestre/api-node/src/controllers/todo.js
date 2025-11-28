const Todo=require('../models/todo');

const getAllTodos=async(req,res)=>{
  try{
    const todos=await Todo.findAll();
    return res.json(todos);
  }catch(err){
    res.status(500).json({error:err.message});
  }
};

const getTodoById=async(req,res)=>{
  try{
    const todoId=req.params.todo_id;
    const todo=await Todo.findByPk(todoId);
    if(!todo)return res.status(404).json({error:'todo not found'});
    return res.json(todo);
  }catch(err){
    res.status(500).json({error:err.message});
  }
};

const deleteTodoById=async(req,res)=>{
  const todoId=req.params.todo_id;

  try{
    const affectedRows=await Todo.destroy({where:{id:todoId}});

    if(affectedRows===0)return res.status(404).json({message:'todo not found'});

    return res.json({message:'todo successfully deleted'});
  }catch(err){
    return res.status(500).json({message:err.mesage});
  }
}

module.exports={
  getAllTodos,
  getTodoById,
  deleteTodoById,
};
