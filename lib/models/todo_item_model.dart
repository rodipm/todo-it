import 'dart:convert';

class TodoItemModel {
  String title;
  String description;
  bool done;
  bool selected;
  bool starred;
  int groupId;

  TodoItemModel(
      {this.title,
      this.done,
      this.selected,
      this.description,
      this.starred});

  TodoItemModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        done = json['done'],
        selected = json['selected'],
        starred = json['starred'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'done': done,
        'selected': selected,
        'starred': starred,
      };

  @override
  String toString() {
    return jsonEncode({'title': title, 'description': description, 'done': done, 'selected': selected, 'starred': starred});
  }
}
