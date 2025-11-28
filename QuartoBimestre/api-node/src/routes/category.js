const router=require('express').Router();
const categoryController=require('../controllers/category');

router.get('/',categoryController.getAllCategories);
router.get('/:category_id',categoryController.getCategoryById)
router.delete('/:category_id',categoryController.deleteCategoryById);

module.exports=router;
