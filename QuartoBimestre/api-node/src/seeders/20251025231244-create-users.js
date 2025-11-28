'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.bulkInsert('User',[
      {
        id:1,
        name:'Faraday',
        email:'faraday@gmail.com',
        password:'Faraday123!',
      },
      {
        id:2,
        name:'Elizabeth Tudor',
        email:'elizabeth.tudor@gmail.com',
        password:'ElizabethTudor123!',
      },
      {
        id:3,
        name:'Isaac',
        email:'isaac.newton@gmail.com',
        password:'IsaacNewton123!',
      },
    ]);
  },
  async down (queryInterface, Sequelize) {
    await queryInterface.bulkDelete('User',{id:[1,2,3]});
  }
};
