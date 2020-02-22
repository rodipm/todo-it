import 'dart:convert';
import 'dart:io';
import 'package:TodoList/models/todo_item_model.dart';
import 'package:path_provider/path_provider.dart';

class DataUtil {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/todo_list.json');
  }

  Future<File> writeTodoListItems(List<TodoItemModel> todoList) async {
    final file = await _localFile;
    var todoListItems = {'todoListItems': []};

    for (TodoItemModel item in todoList)
      todoListItems['todoListItems'].add(item.toJson());

    return file.writeAsString(jsonEncode(todoListItems));
  }

  Future<List<TodoItemModel>> readTodoListItems() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      List<TodoItemModel> todoListItems = [];
      for (var itemJson in jsonDecode(contents)['todoListItems'])
        todoListItems.add(TodoItemModel.fromJson(itemJson));
      return todoListItems;
    } catch (e) {
      return [];
    }
  }
}
