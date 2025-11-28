const User=require('./user');
const Todo=require('./todo');
const Category=require('./category');
const CategoryNormal=require('./category_normal');
const CategoryPeriodic=require('./category_periodic');

User.hasMany(Category,{foreignKey:'user_id'});
Category.belongsTo(User,{foreignKey:'user_id'});

Category.hasMany(Todo,{foreignKey:'category_id',as:'todos',onDelete:'CASCADE'});
Todo.belongsTo(Category,{foreignKey:'category_id',as:'category'});

User.hasMany(Todo,{foreignKey:'user_id'})
Todo.belongsTo(User,{foreignKey:'user_id'});

Category.hasOne(CategoryNormal,{
  foreignKey:'id',
  onDelete:'CASCADE',
});
CategoryNormal.belongsTo(Category,{
  foreignKey:'id',
  onDelete:'CASCADE',
});

Category.hasOne(CategoryPeriodic,{
  foreignKey:'id',
  onDelete:'CASCADE',
});
CategoryPeriodic.belongsTo(Category,{
  foreignKey:'id',
  onDelete:'CASCADE',
});

