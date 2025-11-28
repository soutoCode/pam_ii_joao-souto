'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize){
    await queryInterface.createTable('Category_Normal',{
      id:{
        type:Sequelize.INTEGER,
        allowNull:false,
        primaryKey:true,
        autoIncrement:true,
        references:{
          model:'Category',
          key:'id',
        },
        onDelete:'CASCADE',
        onUpdate:'CASCADE',
      },
      due_date:{
        type:Sequelize.DATEONLY,
        allowNull:true,
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

    await queryInterface.createTable('Category_Periodic',{
      id:{
        type:Sequelize.INTEGER,
        allowNull:false,
        primaryKey:true,
        autoIncrement:true,
        references:{
          model:'Category',
          key:'id',
        },
        onDelete:'CASCADE',
        onUpdate:'CASCADE',
      },
      repeat_interval_days:{
        type:Sequelize.INTEGER,
        allowNull:false,
      },
      automatic_mode:{
        type:Sequelize.BOOLEAN,
        allowNull:false,
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
  async down(queryInterface, Sequelize){
    await queryInterface.dropTable('Category_Normal');
    await queryInterface.dropTable('Category_Periodic');
  },
};
