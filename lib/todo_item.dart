import 'package:hive/hive.dart';
part 'todo_item.g.dart';

@HiveType(typeId: 1)
class ToDoItem
{
  @HiveField(0)
  final String title;
  
  @HiveField(1,defaultValue: false)
  final bool isCompleted;

  ToDoItem(this.title,this.isCompleted);
}