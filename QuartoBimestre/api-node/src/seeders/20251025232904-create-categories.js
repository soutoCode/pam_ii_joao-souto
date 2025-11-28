'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize){
    await queryInterface.bulkInsert('Category',[
      {
        id:1,
        name:'Escola',
        color:'#FF9B87',
        icon:'School',
        type:'normal',
        user_id:1,
      },
      {
        id:2,
        name:'Livros da Fuvest',
        color:'#FFD7DD',
        icon:'School',
        type:'normal',
        user_id:1,
      },
      {
        id:3,
        name:'Ideas',
        color:'#ADDAD5',
        icon:null,
        type:'periodic',
        user_id:1,
      },
      {
        id:4,
        name:'Faculdade',
        color:'#D8BFA7',
        icon:'Mail',
        type:'normal',
        user_id:2,
      },
      {
        id:5,
        name:'História',
        color:'#FFD7DD',
        icon:'School',
        type:'normal',
        user_id:2,
      },
    ]);

    await queryInterface.bulkInsert('Category_Normal',[
      {id:1,due_date:null},
      {id:2,due_date:new Date('2025-11-12')},
      {id:4,due_date:null},
      {id:5,due_date:null},
    ]);

    await queryInterface.bulkInsert('Category_Periodic',[
      {id:3,repeat_interval_days:7,automatic_mode:false},
    ]);
  },
  async down(queryInterface, Sequelize){
    await queryInterface.bulkInsert('Category_Periodic',{id:[3]});
    await queryInterface.bulkInsert('Category_Normal',{id:[1,2,4,5]});
    await queryInterface.bulkDelete('Category',{id:[1,2,3,4,5]});
  },
};
