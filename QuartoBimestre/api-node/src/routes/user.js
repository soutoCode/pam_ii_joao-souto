const router=require('express').Router();
const userController=require('../controllers/user');

router.get('/',userController.getAllUsers);
router.post('/',userController.createUser);

router.get('/:user_id',userController.getUserById);
router.delete('/:user_id',userController.deleteUserById);

module.exports=router;
