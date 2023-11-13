import 'package:hive/hive.dart';
import 'package:todo_app/todo_item.dart';

class TodoService{
  final String boxName = "todobox";
  Future<Box<ToDoItem>> get _box async => await Hive.openBox<ToDoItem>(boxName);

  Future<void> AddToDoItem(ToDoItem toDoItem) async 
  {
    var box =  await _box;
    box.add(toDoItem);
  }

  Future<List<ToDoItem>> GetAllToDos() async
  {
    var box = await _box;
    return box.values.toList();
  }

  Future<void> DeleteToDoItem(int index) async 
  {
    var box = await _box;
    box.deleteAt(index);
  }

  Future<void> UpdatedIsCompleted(int index,ToDoItem toDoItem) async 
  {
    var box = await _box;
    toDoItem.isCompleted = !toDoItem.isCompleted;
    await box.putAt(index, toDoItem);
  }


}