import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ToDoIt/models/group_item_model.dart';

import '../models/todo_item_model.dart';
import 'package:path_provider/path_provider.dart';

class DataUtil {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/ToDoIt_dsadsaddsadsasad.json');
  }

  Future<File> writeGroup(String title) async {
    Map<String, Object> jsonContents;
    final file = await _localFile;

    try {
      String contents = await file.readAsString();
      jsonContents = jsonDecode(contents);
    } catch (e) {
      jsonContents = Map<String, Object>();
    }
    jsonContents.addAll({"$title": []});

    return file.writeAsString(jsonEncode(jsonContents));
  }

  Future<bool> removeGroup(String title) async {
    try {
      print("Removing group");
      final file = await _localFile;
      String contents = await file.readAsString();
      print("Contents:");
      print(inspect(contents));
      Map<String, dynamic> jsonContents = jsonDecode(contents);
      print("jsonContents:");
      print(inspect(jsonContents));
      jsonContents.remove(title);
      print("Removed:");
      print(inspect(jsonContents));

      file.writeAsString(jsonEncode(jsonContents));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<File> writeTodoListItemsToGroup(
      List<TodoItemModel> todoList, String groupTitle) async {
    final file = await _localFile;
    var todoListItems = {groupTitle: []};

    for (TodoItemModel item in todoList)
      todoListItems[groupTitle].add(item.toJson());

    return file.writeAsString(jsonEncode(todoListItems));
  }

  Future<List<TodoItemModel>> readTodoListItemsFromGroup(
      String groupTitle) async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      List<TodoItemModel> todoListItems = [];
      for (var itemJson in jsonDecode(contents)[groupTitle])
        todoListItems.add(TodoItemModel.fromJson(itemJson));
      return todoListItems;
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, int>> readGroupTodoItemsStats(String groupTitle) async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      Map<String, int> groupItemsStats = {
        "starred": 0,
        "done": 0,
        "todo": 0,
      };
      for (var itemJson in jsonDecode(contents)[groupTitle]) {
        if (itemJson.starred)
          groupItemsStats["starred"]++;
        else if (itemJson.done)
          groupItemsStats["done"]++;
        else
          groupItemsStats["todo"]++;
      }
      return groupItemsStats;
    } catch (e) {
      return {
        "starred": 0,
        "done": 0,
        "todo": 0,
      };
    }
  }

  Future<List<GroupItemModel>> readGroupItems() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      Map<String, Object> jsonContents = jsonDecode(contents);
      List<String> groupTitles = jsonContents.keys.toList();

      List<GroupItemModel> groupItems = [];

      for (String _title in groupTitles) {
        GroupItemModel groupItemModel = GroupItemModel(title: _title);
        await groupItemModel.init();
        groupItems.add(groupItemModel);
      }

      return groupItems;
    } catch (e) {
      return [];
    }
  }
}
