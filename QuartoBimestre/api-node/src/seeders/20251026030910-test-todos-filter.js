'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize){
    await queryInterface.bulkInsert('Todo',[
      {
        id:8,
        title:'Estudar sobre a Era Vargas',
        is_done:true,
        completed_at:new Date('2025-10-10'),
        due_date:new Date('2025-10-28'),
        user_id:2,
        category_id:5,
      },
      {
        id:9,
        title:'Ler Investigações Filosóficas',
        is_done:false,
        due_date:new Date('2025-10-28'),
        user_id:2,
        category_id:4,
      },
      {
        id:10,
        title:'Apresentação do TCC',
        is_done:true,
        completed_at:new Date('2025-10-22'),
        due_date:new Date('2025-10-22'),
        user_id:2,
        category_id:4,
      },
      {
        id:11,
        title:'Prova de sociologia',
        is_done:false,
        completed_at:null,
        due_date:new Date('2025-12-13'),
        user_id:2,
        category_id:4,
      },
      {
        id:12,
        title:'Apresentação da Revolução Gloriosa',
        is_done:true,
        completed_at:new Date('2025-10-31'),
        due_date:new Date('2025-10-31'),
        user_id:2,
        category_id:4,
      },
    ]);
  },
  async down (queryInterface, Sequelize){
    await queryInterface.bulkDelete('Todo',{id:[8,9,10,11,12]});
  },
};
