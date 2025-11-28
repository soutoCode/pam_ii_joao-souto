const {Sequelize}=require('sequelize');

// Setting up database
const sequelize=new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USERNAME,
  process.env.DB_PASSWORD,
  {
    host:'localhost',
    dialect:'mysql',
    define:{
      freezeTableName:true,
      underscored:true,
      createdAt:'created_at',
      updatedAt:'updated_at',
    },
  },
);

module.exports=sequelize;
