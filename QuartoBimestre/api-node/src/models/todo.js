const {DataTypes}=require('sequelize');
const database=require('../config/database');

const Todo=database.define('Todo',{
  title:{
    type:DataTypes.STRING,
    allowNull:false,
  },
  is_done:{
    type:DataTypes.BOOLEAN,
    allowNull:false,
  },
  due_date:{
    type:DataTypes.DATEONLY,
    allowNull:true,
  },
  completed_at:{
    type:DataTypes.DATEONLY,
    allowNull:true,
  },
});

module.exports=Todo;
