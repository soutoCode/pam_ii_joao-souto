'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize){
    await queryInterface.bulkInsert('Todo',[
      {
        id:13,
        title:'Atividade de filosofia no Teams',
        is_done:true,
        completed_at:new Date('2025-10-29'),
        due_date:new Date(),
        user_id:2,
        category_id:4,
      },
      {
        id:14,
        title:'Demonstração do TCC',
        is_done:false,
        due_date:new Date(),
        user_id:2,
        category_id:4,
      },
    ]);
  },
  async down (queryInterface, Sequelize){
    await queryInterface.bulkDelete('Todo',{id:[13,14]});
  },
};
