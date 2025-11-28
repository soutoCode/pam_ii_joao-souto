const jwt=require('jsonwebtoken');
const User = require('../models/user');

const requireAuth=async(req,res,next)=>{
  const header=req.headers.authorization;
  if(!header)return res.status(401).json({error:'no token provided'});

  const accessToken=header.split(' ')[1];

  try{
    const decoded=jwt.verify(accessToken,process.env.JWT_SECRET);

    if(!decoded)return res.status(401).json({error:'token invalid 1'});

    const user=await User.findByPk(decoded.userId);
    if(!user)return res.status(401).json({error:'token invalid 2'});

    req.userId=user.id;
    next();
  }catch (err){
    res.status(401).json({error:'Invalid or expired token: '+err});
  }
};

module.exports={requireAuth};
