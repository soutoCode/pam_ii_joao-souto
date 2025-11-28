'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize){
    await queryInterface.addColumn('Todo','completed_at',{
      type:Sequelize.DATEONLY,
      allowNull:true,
    });
  },
  async down (queryInterface, Sequelize){
    await queryInterface.removeColumn('Todo','completed_at');
  },
};
