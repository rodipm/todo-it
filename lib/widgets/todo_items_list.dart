import 'package:ToDoIt/utils/data_util.dart';
import 'package:flutter/material.dart';
import './todo_item.dart';
import '../models/todo_item_model.dart';

class TodoItemsList extends StatefulWidget {
  final DataUtil storage;
  TodoItemsList({Key key, this.storage}) : super(key: key);
  @override
  _TodoItemsListState createState() => _TodoItemsListState();
}

class _TodoItemsListState extends State<TodoItemsList> {
  bool _loadingList;
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _descTextController = TextEditingController();
  String _currentlySelectedMode = "All";

  List<TodoItemModel> filteredItems = [];
  List<int> filteredItemsIndexes = [];

  List<TodoItemModel> todoItems;

  @override
  void initState() {
    super.initState();
    _loadingList = true;
    widget.storage.readTodoListItems().then((value) {
      setState(() {
        todoItems = value;
        _loadingList = false;
        _filterItems();
      });
    });
  }

  void _addItem(String _title, String _description) {
    if (_title.length > 0) {
      setState(() {
        todoItems = List.from(todoItems)
          ..add(TodoItemModel(
              title: _title,
              completed: false,
              description: _description,
              selected: false,
              starred: false));
        _filterItems();
      });
      widget.storage.writeTodoListItems(todoItems);
    }
  }

  void _removeItem(int itemId) {
    setState(() {
      todoItems = List.from(todoItems)..removeAt(itemId);
      _filterItems();
    });
    widget.storage.writeTodoListItems(todoItems);
  }

  void _toggleCompleted(int itemId) {
    setState(() {
      todoItems[itemId].completed = !todoItems[itemId].completed;
      _filterItems();
    });
    widget.storage.writeTodoListItems(todoItems);
  }

  void _toggleStarred(int itemId) {
    setState(() {
      todoItems[itemId].starred = !todoItems[itemId].starred;
      _filterItems();
    });
    widget.storage.writeTodoListItems(todoItems);
  }

  void _toggleSelected(int itemId) {
    setState(() {
      todoItems[itemId].selected = !todoItems[itemId].selected;
      _filterItems();
    });
    widget.storage.writeTodoListItems(todoItems);
  }

  void _editItem(int itemId, String _title, String _description) {
    if (_title.length > 0) {
      setState(() {
        todoItems[itemId].title = _title;
        todoItems[itemId].description = _description;
        _filterItems();
      });
      widget.storage.writeTodoListItems(todoItems);
    }
  }

  void _filterItems() {
    setState(() {
      filteredItems = [];
      filteredItemsIndexes = [];
      for (int i = 0; i < todoItems.length; i++) {
        if (_currentlySelectedMode == "Done" && !todoItems[i].completed)
          continue;
        else if (_currentlySelectedMode == "Todo" && todoItems[i].completed)
          continue;
        else if (_currentlySelectedMode == "Starred" && !todoItems[i].starred)
          continue;
        filteredItems.add(todoItems[i]);
        filteredItemsIndexes.add(i);
      }
    });
  }

  void _displayAddItemDialogName(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create new todo item:"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: this._nameTextController,
                decoration: InputDecoration(hintText: "Todo name..."),
              ),
              TextField(
                controller: this._descTextController,
                decoration: InputDecoration(hintText: "Todo description..."),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Add"),
              onPressed: () {
                _addItem(_nameTextController.text, _descTextController.text);
                _nameTextController.clear();
                _descTextController.clear();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _displayEditItemDialog(int itemId, BuildContext context) async {
    this._nameTextController.text = todoItems[itemId].title;
    this._descTextController.text = todoItems[itemId].description;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit item informations:"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: this._nameTextController,
                decoration: InputDecoration(hintText: "Todo name..."),
              ),
              TextField(
                controller: this._descTextController,
                decoration: InputDecoration(hintText: "Todo description..."),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Done"),
              onPressed: () {
                _editItem(
                    itemId, _nameTextController.text, _descTextController.text);
                _nameTextController.clear();
                _descTextController.clear();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo-it!"),
        actions: <Widget>[
          DropdownButton(
            items: [
              DropdownMenuItem(
                child: Text("All"),
                value: "All",
              ),
              DropdownMenuItem(
                child: Text("Done"),
                value: "Done",
              ),
              DropdownMenuItem(
                child: Text("Todo"),
                value: "Todo",
              ),
              DropdownMenuItem(
                child: Text("Starred"),
                value: "Starred",
              ),
            ],
            onChanged: (String value) {
              this._currentlySelectedMode = value;
              this._filterItems();
            },
            value: this._currentlySelectedMode,
            isExpanded: false,
          )
        ],
      ),
      body: this._loadingList
          ? Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(50),
                    child: Text(
                      "Loading Todo List...",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  CircularProgressIndicator(
                    backgroundColor: Colors.deepOrange,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final currentItem = filteredItems[index];
                final itemIndex = filteredItemsIndexes[index];
                return TodoItem(
                  editItemHandler: () =>
                      this._displayEditItemDialog(itemIndex, context),
                  removeItemHandler: () => this._removeItem(itemIndex),
                  selectHandler: () => this._toggleSelected(itemIndex),
                  toggleCompleteHandler: () => this._toggleCompleted(itemIndex),
                  toggleStarreHandler: () => this._toggleStarred(itemIndex),
                  todoItem: currentItem,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayAddItemDialogName(context),
          backgroundColor: Colors.deepOrange,
          child: Icon(Icons.add)),
    );
  }
}
