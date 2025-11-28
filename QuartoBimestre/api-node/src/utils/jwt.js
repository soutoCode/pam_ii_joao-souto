const jwt=require('jsonwebtoken');

const generateAccessToken=(userId)=>{
  const accessToken=jwt.sign(
    {userId},
    process.env.JWT_SECRET,
    {expiresIn:'3h'},
  );

  return accessToken;
};

module.exports={generateAccessToken};
