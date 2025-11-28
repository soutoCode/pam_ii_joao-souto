'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize){
    await queryInterface.addColumn('Category','type',{
      type:Sequelize.ENUM('normal','periodic'),
      allowNull:false,
    });
  },
  async down(queryInterface, Sequelize){
    await queryInterface.removeColumn('Category','type');
  },
};
