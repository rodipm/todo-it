import 'dart:developer';

import 'package:ToDoIt/utils/data_util.dart';
import 'dart:async';

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
    print("Init GroupItemModel");
    Map<String, int> _stats = await DataUtil().readGroupTodoItemsStats(this.title);
    print(inspect(_stats));
    numDone = _stats['done'];
    numTodo = _stats['todo'];
    numStarred = _stats['starred'];
  }
}