import 'package:ToDoIt/models/group_item_model.dart';
import 'package:ToDoIt/utils/data_util.dart';
import 'package:flutter/material.dart';

class GroupItem extends StatelessWidget {
  final GroupItemModel groupItem;
  final DataUtil storage;
  final Function editGroupHandler;
  final Function removeGroupHandler;
  final Function selectGroupHandler;

  GroupItem(
      {this.groupItem,
      this.editGroupHandler,
      this.removeGroupHandler,
      this.storage,
      this.selectGroupHandler});

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: GestureDetector(
        onTap: this.selectGroupHandler,
        child: Card(
          color: Colors.deepOrange.withAlpha(80),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: this.editGroupHandler,
                      icon: Icon(Icons.edit),
                      color: Colors.grey,
                    ),
                    IconButton(
                      onPressed: this.removeGroupHandler,
                      icon: Icon(Icons.close),
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        groupItem.title,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.deepOrange,
                            ),
                            Text(groupItem.numStarred.toString()),
                          ],
                        )),
                        Container(
                            child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                            Text(groupItem.numDone.toString())
                          ],
                        )),
                        Container(
                            child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.done,
                              color: Colors.grey,
                            ),
                            Text(groupItem.numTodo.toString()),
                          ],
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
