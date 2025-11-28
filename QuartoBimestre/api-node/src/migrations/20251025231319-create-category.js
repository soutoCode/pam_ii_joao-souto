'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.createTable('Category',{
      id:{
        type:Sequelize.INTEGER,
        allowNull:false,
        primaryKey:true,
        autoIncrement:true,
      },
      name:{
        type:Sequelize.STRING,
        allowNull:false,
      },
      color:{
        type:Sequelize.STRING,
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
  async down (queryInterface, Sequelize) {
    await queryInterface.dropTable('Category');
  }
};
