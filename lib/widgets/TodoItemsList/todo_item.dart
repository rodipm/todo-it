import 'package:flutter/material.dart';
import '../../models/todo_item_model.dart';

class TodoItem extends StatelessWidget {
  final TodoItemModel todoItem;
  final Function removeItemHandler;
  final Function toggleCompleteHandler;
  final Function selectHandler;
  final Function editItemHandler;
  final Function toggleStarreHandler;

  const TodoItem(
      {this.removeItemHandler,
      this.toggleCompleteHandler,
      this.toggleStarreHandler,
      this.selectHandler,
      this.editItemHandler,
      this.todoItem});

  buildView(_isdone, _isSelected, _isStarred, BuildContext context) {
    List<Widget> _finalView = [];

    _finalView.add(
      Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 0),
              child: IconButton(
                icon: _isStarred
                    ? Icon(
                        Icons.star,
                        size: 20,
                        color: Colors.deepOrange,
                      )
                    : Icon(
                        Icons.star_border,
                        size: 20,
                        color: Colors.grey,
                      ),
                onPressed: this.toggleStarreHandler,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.50,
              child: Text(
                this.todoItem.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: this.toggleCompleteHandler,
                    icon: Icon(Icons.done,
                        color: _isdone ? Colors.deepOrange : Colors.grey),
                  ),
                  IconButton(
                    onPressed: this.removeItemHandler,
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

    if (_isSelected) {
      _finalView.add(Divider(
        color: Colors.black,
        thickness: 0.2,
      ));
      _finalView.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Title:",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: this.editItemHandler,
                    icon: Icon(
                      Icons.edit,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
              child: Text(
                "${todoItem.title}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
              child: Text(
                "Description:",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
              child: Text(
                "${todoItem.description}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      );
    }
    return _finalView;
  }

  @override
  Widget build(BuildContext context) {
    bool _isdone = this.todoItem.done;
    bool _isSelected = this.todoItem.selected;
    bool _isStarred = this.todoItem.starred;

    return GestureDetector(
      onTap: this.selectHandler,
      child: Container(
        color: Colors.orange.withAlpha(80),
        margin: EdgeInsets.all(10.0),
        child: Column(
          children:
              this.buildView(_isdone, _isSelected, _isStarred, context),
        ),
      ),
    );
  }
}
