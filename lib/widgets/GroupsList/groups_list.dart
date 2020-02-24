import 'package:ToDoIt/models/group_item_model.dart';
import 'package:ToDoIt/utils/data_util.dart';
import 'package:ToDoIt/widgets/GroupsList/group_item.dart';
import 'package:flutter/material.dart';
import '../TodoItemsList/todo_items_list.dart';

class GroupsList extends StatefulWidget {
  final DataUtil storage;

  GroupsList({Key key, this.storage}) : super(key: key);

  @override
  _GroupsListState createState() => _GroupsListState();
}

class _GroupsListState extends State<GroupsList> {
  TextEditingController _groupTextController = TextEditingController();

  List<GroupItemModel> groupItems = [];

  @override
  void initState() {
    super.initState();
    _updateGroups();
  }

  void _updateGroups() {
    widget.storage.readGroupItems().then((_groupItems) {
      setState(() {
        groupItems = _groupItems;
      });
    });
  }

  void _addGroup(String _title) {
    List<String> _groupTitles = groupItems.map((e) => e.title).toList();

    if (_title.length > 0 && !_groupTitles.contains(_title)) {
      setState(() {
        groupItems = List.from(groupItems)..add(GroupItemModel(title: _title));
      });
      widget.storage.writeGroup(_title);
    }
  }

  void _removeGroup(int groupTitle) {
    String _groupTitle = groupItems[groupTitle].title;
    setState(() {
      groupItems = List.from(groupItems)..removeAt(groupTitle);
    });
    widget.storage.removeGroup(_groupTitle);
  }

  void _editGroup(int groupTitle, String _title) async {
    List<String> _groupTitles = groupItems.map((e) => e.title).toList();
    String _oldTitle = groupItems[groupTitle].title;
    if (_title.length > 0 && !_groupTitles.contains(_title)) {
      setState(() {
        groupItems[groupTitle].title = _title;
      });
      await widget.storage.editGroup(_oldTitle, _title);
    }
  }

  void _selectGroup(String _groupTitlem, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoItemsList(
          storage: DataUtil(),
          groupTitle: _groupTitlem,
        ),
      ),
    ).then(
      (value) => this._updateGroups(),
    );
  }

  void _displayEditItemDialog(int itemId, BuildContext context) async {
    this._groupTextController.text = groupItems[itemId].title;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit group informations:"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: this._groupTextController,
                decoration: InputDecoration(hintText: "Group name..."),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Done"),
              onPressed: () {
                _editGroup(itemId, _groupTextController.text);
                _groupTextController.clear();
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

  void _displayAddGroupDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create new group::"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: this._groupTextController,
                decoration: InputDecoration(hintText: "Group name..."),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Add"),
              onPressed: () {
                _addGroup(_groupTextController.text);
                _groupTextController.clear();
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
      ),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: groupItems.length,
        itemBuilder: (BuildContext context, int index) {
          return GroupItem(
            groupItem: groupItems[index],
            editGroupHandler: () => this._displayEditItemDialog(index, context),
            removeGroupHandler: () => this._removeGroup(index),
            selectGroupHandler: () =>
                this._selectGroup(groupItems[index].title, context),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayAddGroupDialog(context),
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.add),
      ),
    );
  }
}
