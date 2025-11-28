const router=require('express').Router();
const registerController=require('../controllers/register');

router.post('/step-1',registerController.registerUserStep1);
router.post('/step-2',registerController.registerUserStep2);

module.exports=router;
