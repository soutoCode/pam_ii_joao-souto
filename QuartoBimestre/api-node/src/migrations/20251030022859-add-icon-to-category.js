'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize){
    await queryInterface.addColumn('Category','icon',{
      type:Sequelize.STRING,
      allowNull:true,
    });
  },
  async down (queryInterface, Sequelize){
    await queryInterface.removeColumn('Category','icon');
  },
};
