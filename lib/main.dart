import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/todo_item.dart';
import 'package:todo_app/todo_service.dart';

void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(ToDoItemAdapter());  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final TodoService todoService = TodoService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: todoService.GetAllToDos(),
        builder: (BuildContext context, AsyncSnapshot<List<ToDoItem>> snapshot){
          if(snapshot.connectionState == ConnectionState.done)
          {
             return ToDoListPage(snapshot.data ?? []);
          }
          return const CircularProgressIndicator();
        },
      )
    );
  }
}

class ToDoListPage extends StatefulWidget {
  final List<ToDoItem> todos;

  ToDoListPage(this.todos);

  @override
  ToDoListPageState createState() => ToDoListPageState();
}

class ToDoListPageState extends State<ToDoListPage> {

  final TodoService todoService = TodoService();
  final TextEditingController textEditingController = TextEditingController();
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do List App"),centerTitle: true,
        backgroundColor: Colors.black38,
      ),
         body: ValueListenableBuilder(
        valueListenable: Hive.box<ToDoItem>('todoBox').listenable(),
        builder: (context, Box<ToDoItem> box, _) {
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              var todo = box.getAt(index);
              return ListTile(
                title: Text(todo!.title),
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (val) {
                    todoService.UpdatedIsCompleted(index, todo);
                  },
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    todoService.DeleteToDoItem(index);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: const Text('Add Todo'),
              content: TextField(
                controller: textEditingController,
              ),
              actions: [
                ElevatedButton(
                  child: const Text('Add'),
                  onPressed: () async {
                     var todo = ToDoItem(textEditingController.text, false);
                     await todoService.AddToDoItem(todo);
                     Navigator.pop(context);
                  },
                )
              ],
            );

          }
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

