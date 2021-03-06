import 'dart:async';
import 'package:ToDoIt/utils/data_util.dart';

class GroupItemModel {
  String title;
  int numDone;
  int numTodo;
  int numStarred;

  GroupItemModel({this.title}){
    numDone = 0;
    numTodo = 0;
    numStarred = 0;
  }

  Future<void> init() async {
    Map<String, int> _stats = await DataUtil().readGroupTodoItemsStats(this.title);
    numDone = _stats['done'];
    numTodo = _stats['todo'];
    numStarred = _stats['starred'];
  }
}