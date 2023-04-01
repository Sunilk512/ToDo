import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:to_do_list_with_firebase/firebase_helper.dart';
import 'package:to_do_list_with_firebase/loginpage.dart';
import 'package:to_do_list_with_firebase/todo_task.dart';

//ignore_for_file: prefer_const_constructors

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoTask> todos = [];
  bool _isLoading = false;

  bool _isStackLoading = false;
  int idCounter = 0;

  final _addTaskController = TextEditingController();
  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ));
  }

  @override
  void initState() {
    super.initState();
    getTodoList();
  }

  Future<void> getTodoList() async {
    _isLoading = true;
    _notify();
    final resposese = await FirebaseHelper.getUserTodo;

    todos = resposese.todoList;
    idCounter = resposese.todoList.length;
    _isLoading = false;
    _notify();
  }

  Future<void> _displayTextInputDialog(
    BuildContext context, {
    bool isForUpdate = false,
    int? todoId,
  }) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'Add Task',
              style: TextStyle(color: Colors.black),
            ),
            content: TextField(
              style: TextStyle(color: Colors.black),
              controller: _addTaskController,
              decoration: InputDecoration(
                hintText: isForUpdate ? "Update Task Here" : "Add Task Here",
                hintStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  if (_addTaskController.text.trim().isEmpty) {
                    Fluttertoast.showToast(
                        msg: 'Please enter task',
                        backgroundColor: Colors.white,
                        textColor: Colors.black);
                    return;
                  }
                  Navigator.pop(context);
                  _isStackLoading = true;
                  _notify();
                  if (isForUpdate) {
                    final isSucess = await FirebaseHelper.updateTodo(
                      TodoTask(
                        id: todoId,
                        task: _addTaskController.text.trim(),
                      ),
                    );
                    if (isSucess == 'success') {
                      todos = List<TodoTask>.from(todos).map((e) {
                        if (e.id == todoId) {
                          return TodoTask(
                            id: todoId,
                            task: _addTaskController.text.trim(),
                          );
                        }
                        return e;
                      }).toList();
                    } else {
                      Fluttertoast.showToast(
                          msg: isSucess,
                          backgroundColor: Colors.white,
                          textColor: Colors.black);
                    }
                    _isStackLoading = false;
                    _addTaskController.clear();
                    _notify();
                    return;
                  }

                  idCounter += 1;
                  _notify();

                  final isSucess = await FirebaseHelper.addTask(
                    TodoTask(
                      id: idCounter,
                      task: _addTaskController.text.trim(),
                    ),
                  );

                  if (isSucess == 'success') {
                    todos.add(TodoTask(
                      id: idCounter,
                      task: _addTaskController.text.trim(),
                    ));
                  } else {
                    Fluttertoast.showToast(
                        msg: isSucess,
                        backgroundColor: Colors.white,
                        textColor: Colors.black);
                  }

                  _isStackLoading = false;
                  _addTaskController.clear();
                  _notify();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withOpacity(0.8),
        onPressed: () {
          _displayTextInputDialog(context);
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        automaticallyImplyLeading: false,
        title: Row(
          children: const <Widget>[
            Text("To Do List"),
          ],
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                logout();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              )),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getTodoList();
        },
        child: Stack(
          children: [
            Builder(
              builder: (context) {
                if (_isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: ListTile(
                        onTap: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        tileColor: Colors.grey[800],
                        leading: Container(
                            child: IconButton(
                                color: Colors.white54,
                                onPressed: () {
                                  _addTaskController.text =
                                      todos[index].task ?? '';
                                  _displayTextInputDialog(
                                    context,
                                    isForUpdate: true,
                                    todoId: todos[index].id,
                                  );
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ))),
                        title: Text('${todos[index].task}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[100],
                            )),
                        trailing: Container(
                            padding: EdgeInsets.all(0),
                            margin: EdgeInsets.symmetric(vertical: 12.0),
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.red[700],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: IconButton(
                              color: Colors.white,
                              iconSize: 18,
                              onPressed: () async {
                                _isStackLoading = true;
                                _notify();
                                final isSuccess =
                                    await FirebaseHelper.deleteTodo(
                                  todos[index].id ?? 0,
                                );
                                if (isSuccess == 'success') {
                                  todos.remove(todos[index]);
                                }
                                _isStackLoading = false;
                                _notify();
                              },
                              icon: Icon(Icons.delete),
                            )),
                      ),
                    );
                  },
                );
              },
            ),
            if (_isStackLoading) Center(child: CircularProgressIndicator())
          ],
        ),
      ),
    );
  }

  void _notify() {
    if (mounted) {
      setState(() {});
    }
  }
}
