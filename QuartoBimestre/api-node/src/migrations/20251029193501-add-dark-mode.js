'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize){
    await queryInterface.addColumn('User','is_dark_mode_preferred',{
      type:Sequelize.BOOLEAN,
      allowNull:false,
      defaultValue:false,
    });
  },
  async down (queryInterface, Sequelize){
    await queryInterface.removeColumn('User','is_dark_mode_preferred');
  },
};
