'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.createTable('Todo',{
      id:{
        type:Sequelize.INTEGER,
        allowNull:false,
        primaryKey:true,
        autoIncrement:true,
      },
      title:{
        type:Sequelize.STRING,
        allowNull:false,
      },
      is_done:{
        type:Sequelize.BOOLEAN,
        allowNull:false,
      },
      due_date:{
        type:Sequelize.DATEONLY,
        allowNull:false,
      },
      user_id:{
        type:Sequelize.INTEGER,
        allowNull:false,
        references:{
          model:'User',
          key:'id',
        },
      },
      category_id:{
        type:Sequelize.INTEGER,
        allowNull:false,
        references:{
          model:'Category',
          key:'id',
        },
      },
      created_at:{
        type:Sequelize.DATE,
        allowNull:false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
      updated_at:{
        type:Sequelize.DATE,
        allowNull:false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP')
      },
    });
  },
  async down (queryInterface, Sequelize){
    await queryInterface.dropTable('Todo');
  }
};
