class ICategory{
  final String id;
  String name;
  final String color;
  String? icon;
  String type;

  ICategory({
    required this.id,
    required this.name,
    required this.color,
    required this.type,
    this.icon,
  });

  factory ICategory.fromMap(Map<String,dynamic> map){
    return ICategory(
      id:map['id'].toString(),
      name:map['name'],
      color:map['color'],
      icon:map['icon'],
      type:map['type'],
    );
  }
}
