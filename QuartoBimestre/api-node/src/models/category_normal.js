const {DataTypes}=require('sequelize');
const database=require('../config/database');

const category=database.define('Category_Normal',{
  due_date:{
    type:DataTypes.DATEONLY,
    allowNull:true,
  },
});

module.exports=category;
