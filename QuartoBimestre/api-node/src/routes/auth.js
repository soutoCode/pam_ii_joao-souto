const router=require('express').Router();
const authController=require('../controllers/auth');
const {requireAuth}=require('../middlewares/auth');

router.post('/login',authController.login);
router.get('/me',requireAuth,authController.getMe);
router.patch('/me/theme',requireAuth,authController.toggleTheme);

router.get('/me/categories',requireAuth,authController.getAllCategories);
router.post('/me/categories',requireAuth,authController.createCategory);

router.get('/me/categories/:category_id',requireAuth,authController.getCategoryById);
router.patch('/me/categories/:category_id',requireAuth,authController.updateCategory);
router.delete('/me/categories/:category_id',requireAuth,authController.deleteCategoryById);

router.get('/me/categories/:category_id/todos',requireAuth,authController.getTodosByCategoryId);
router.post('/me/categories/:category_id/todos',requireAuth,authController.createTodo);

router.get('/me/todos',requireAuth,authController.getAllTodos);
router.get('/me/todos/:todo_id',requireAuth,authController.getTodoById);
router.delete('/me/todos/:todo_id',requireAuth,authController.deleteTodoById);
router.patch('/me/todos/:todo_id',requireAuth,authController.updateTodo);

router.delete('/me/todos',requireAuth,authController.deleteTodos); // WHY DO I HAVE THIS?

module.exports=router;
