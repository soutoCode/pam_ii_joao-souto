// Configure .env
const env=process.env.NODE_ENV||'development';
const path=require('path');
const envPath=path.join(
  __dirname,
  '..',
  `.env.${env}`,
);
require('dotenv').config({path:envPath});

// Create App
const express=require('express');
const app=express();
app.use(express.json());

// Configure Router
const router=require('./routes/');
app.use(router);

// Check Database Connection
const sequelize=require('./config/database');
sequelize.authenticate()
  .then(async()=>{
    console.log('Database successfully connected')
    require('./models/index');
  })
  .catch((err)=>console.log('Unable to connect to database: '+err));

// Connect Redis
const {connectRedis}=require('./config/redis');

(async function(){
  await connectRedis()
    .then(()=>console.log('REDIS OK'))
    .catch(err=>console.log('Unable to connect to Redis: '+err));
})();

// Run App
const PORT=process.env.PORT||5000;
app.listen(PORT,'0.0.0.0',()=>{
  console.log(`App running on http://192.168.1.108:${PORT}`);
});
