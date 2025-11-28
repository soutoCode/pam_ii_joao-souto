import 'package:ristretto/core/models/itodo.dart';

enum TodoDetailsType{updated,deleted}

class TodoDetailsResult{
  final TodoDetailsType type;
  final ITodo? todo;

  const TodoDetailsResult({required this.type,this.todo});
}
