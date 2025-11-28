const {DataTypes}=require('sequelize');
const database=require('../config/database');

const User=database.define('User',{
  name:{
    type:DataTypes.STRING,
    allowNull:false,
  },
  email:{
    type:DataTypes.STRING,
    allowNull:false,
    unique:true,
  },
  password:{
    type:DataTypes.STRING,
    allowNull:false,
  },
  is_dark_mode_preferred:{
    type:DataTypes.BOOLEAN,
    allowNull:false,
    defaultValue:false,
  },
});

module.exports=User;
