const Category=require('../models/category');

const getAllCategories=async(req,res)=>{
  try{
    const categories=await Category.findAll();

    return res.json(categories);
  }catch(err){
    return res.status(500).json({err:err.message});
  }
};

const getCategoryById=async(req,res)=>{
  try{
    const category_id=req.params.category_id;
    const category=await Category.findByPk(category_id);

    if(!category)return res.status(404).json({message:'category not found'});

    return res.json(category);
  }catch(err){
    return res.status(500).json({message:err.message});
  }
};

const deleteCategoryById=async(req,res)=>{
  try{
    const category_id=req.params.category_id;
    const affectedRows=await Category.destroy({where:{id:category_id}});

    if(affectedRows===0)return res.status(404).json({message:'category not found'});

    return res.json({message:'category successfully deleted'});
  }catch(err){
    return res.status(500).json({message:err.message});
  }
};

module.exports={
  getAllCategories,
  getCategoryById,
  deleteCategoryById,
};
