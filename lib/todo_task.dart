class TodoTask {
  int? id;
  String? task;

  TodoTask({this.id, this.task});

  TodoTask.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    task = json['task'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['task'] = task;
    return data;
  }
}
