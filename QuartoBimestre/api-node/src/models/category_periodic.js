const {DataTypes}=require('sequelize');
const database=require('../config/database');

const category=database.define('Category_Periodic',{
  repeat_interval_days:{
    type:DataTypes.INTEGER,
    allowNull:false,
  },
  automatic_mode:{
    type:DataTypes.BOOLEAN,
    allowNull:false,
  },
});

module.exports=category;
