import 'package:ristretto/core/models/icategory.dart';

class ITodo{
  final String id;
  String title;
  DateTime? dueDate;
  bool isComplete;
  ICategory? category;
  DateTime createdAt;
  DateTime? completedAt;

  ITodo({
    required this.id,
    required this.title,
    required this.dueDate,
    this.isComplete=false,
    this.category,
    required this.createdAt,
    this.completedAt,
  });

  factory ITodo.fromMap(Map<String,dynamic> map){
    return ITodo(
      id:map['id'].toString(),
      title:map['title'],
      isComplete:map['is_done'],
      dueDate:map['due_date']!=null?DateTime.parse(map['due_date']):null,
      category:map['category']!=null?ICategory.fromMap(map['category']):null,
      createdAt:DateTime.parse(map['created_at']),
      completedAt:map['completed_at']!=null?DateTime.parse(map['completed_at']):null,
    );
  }
}
