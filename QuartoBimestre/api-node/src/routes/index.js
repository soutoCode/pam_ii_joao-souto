const router=require('express').Router();

const userRouter=require('./user');
router.use('/users',userRouter);

const authRouter=require('./auth');
router.use('/auth',authRouter);

const categoryRouter=require('./category');
router.use('/categories',categoryRouter);

const todoRouter=require('./todo');
router.use('/todos',todoRouter);

const registerRouter=require('./register');
router.use('/register',registerRouter);

module.exports=router;
