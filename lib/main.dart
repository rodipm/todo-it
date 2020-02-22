import 'package:TodoList/utils/data_util.dart';
import 'package:flutter/material.dart';
import './widgets/todo_items_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo-it',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: TodoItemsList(storage: DataUtil()),
    );
  }
}