'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize){
    await queryInterface.bulkInsert('Todo',[
      {
        id:1,
        title:'Trabalho do Avelino',
        is_done:false,
        due_date:new Date('2025-11-17'),
        user_id:1,
        category_id:1,
      },
      {
        id:2,
        title:'Prova de português',
        is_done:false,
        due_date:new Date('2025-11-14'),
        user_id:1,
        category_id:1,
      },
      {
        id:3,
        title:'Ler 1984',
        is_done:false,
        due_date:new Date('2025-11-02'),
        user_id:1,
        category_id:2,
      },
      {
        id:4,
        title:'Realizar lista I de exercícios de Cálculo I',
        is_done:true,
        completed_at:new Date('2025-11-24'),
        due_date:new Date('2025-11-29'),
        user_id:1,
        category_id:3,
      },
      {
        id:5,
        title:'Ler O Príncipe de Maquiavel',
        is_done:true,
        completed_at:new Date('2025-10-27'),
        due_date:new Date('2025-11-27'),
        user_id:2,
        category_id:4,
      },
      {
        id:6,
        title:'Apresentação sobre a Guerra Civil Inglesa',
        is_done:true,
        completed_at:new Date('2025-09-26'),
        due_date:new Date('2025-09-26'),
        user_id:2,
        category_id:5,
      },
      {
        id:7,
        title:'Prova de história sobre a Guerra dos 80 anos',
        is_done:false,
        due_date:new Date('2025-11-27'),
        user_id:2,
        category_id:5,
      },
    ]);
  },
  async down (queryInterface, Sequelize){
    await queryInterface.bulkDelete('Todo',{id:[1,2,3,4,5,6,7]});
  },
};
