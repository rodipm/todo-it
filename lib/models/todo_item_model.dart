import 'dart:convert';

class TodoItemModel {
  String title;
  String description;
  bool completed;
  bool selected;
  bool starred;

  TodoItemModel(
      {this.title,
      this.completed,
      this.selected,
      this.description,
      this.starred});

  TodoItemModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        completed = json['completed'],
        selected = json['selected'],
        starred = json['starred'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'completed': completed,
        'selected': selected,
        'starred': starred,
      };

  @override
  String toString() {
    return jsonEncode({'title': title, 'description': description, 'completed': completed, 'selected': selected, 'starred': starred});
  }
}
