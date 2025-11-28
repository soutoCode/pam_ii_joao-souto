'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize){
    await queryInterface.removeConstraint('Todo','Todo_ibfk_2');
    await queryInterface.addConstraint('Todo',{
      fields:['category_id'],
      type:'foreign key',
      name:'Todo_ibfk_2',
      references:{
        table:'Category',
        field:'id',
      },
      onDelete:'CASCADE',
      onUpdate:'CASCADE',
    });
  },
  async down(queryInterface, Sequelize){
    await queryInterface.removeConstraint('Todo','Todo_ibfk_2');
    await queryInterface.addConstraint('Todo',{
      fields:['category_id'],
      type:'foreign key',
      name:'Todo_ibfk_2',
      references:{table:'Category',field:'id'},
      onDelete:'NO ACTION',
      onUpdate:'CASCADE',
    });
  }
};
