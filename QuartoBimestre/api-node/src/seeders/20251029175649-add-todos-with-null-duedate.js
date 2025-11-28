'use strict';

module.exports = {
  async up (queryInterface, Sequelize){
    await queryInterface.bulkInsert('Category',[
      {
        id:6,
        name:'Pessoal',
        color:'#ADDAD5',
        icon:'Profile',
        type:'normal',
        user_id:2,
      },
    ]);

    await queryInterface.bulkInsert('Category_Normal',[
      {id:6,due_date:null},
    ]);

    await queryInterface.bulkInsert('Todo',[
      {
        id:15,
        title:'Arrumar perfil do Linkedin',
        is_done:false,
        due_date:null,
        user_id:2,
        category_id:6,
      },
      {
        id:16,
        title:'Organizar arquivos do computador',
        is_done:true,
        completed_at:new Date('2025-10-15'),
        due_date:null,
        user_id:2,
        category_id:6,
      },
    ]);
  },
  async down (queryInterface, Sequelize){
    await queryInterface.bulkDelete('Category',{id:[6]});
    await queryInterface.bulkDelete('Category_Normal',{id:[6]});
    await queryInterface.bulkDelete('Todo',{id:[15,16]});
  }
};
