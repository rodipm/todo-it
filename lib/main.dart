import 'package:ToDoIt/widgets/GroupsList/groups_list.dart';
import 'package:flutter/material.dart';
import './widgets/TodoItemsList/todo_items_list.dart';
import './utils/data_util.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo-it',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: GroupsList(storage: DataUtil()),
    );
  }
}
