const router=require('express').Router();
const todoController=require('../controllers/todo');

router.get('/',todoController.getAllTodos);
router.get('/:todo_id',todoController.getTodoById);
router.delete('/:todo_id',todoController.deleteTodoById);

module.exports=router;
