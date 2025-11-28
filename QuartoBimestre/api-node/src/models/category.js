const {DataTypes}=require('sequelize');
const database=require('../config/database');

const category=database.define('Category',{
  name:{
    type:DataTypes.STRING(30),
    allowNull:false,
  },
  color:{
    type:DataTypes.STRING(10),
    allowNull:false,
  },
  icon:{
    type:DataTypes.STRING,
    allowNull:true,
  },
  type:{
    type:DataTypes.ENUM('normal','periodic'),
    allowNull:false,
  },
});

module.exports=category;
