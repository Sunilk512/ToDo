import 'package:to_do_list_with_firebase/todo_task.dart';

class TodoListResponse {
  List<TodoTask>? todos;

  TodoListResponse({
    this.todos,
  });

  TodoListResponse.fromJson(Map<String, dynamic> json) {
    if (json['todos'] != null) {
      todos = <TodoTask>[];
      json['todos'].forEach((v) {
        todos!.add(TodoTask.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (todos != null) {
      data['todos'] = todos!.map((e) => e.toJson()).toList();
    }
    return data;
  }

  List<TodoTask> get todoList => todos ?? <TodoTask>[];
}
