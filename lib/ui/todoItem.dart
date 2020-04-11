import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'endpoints.dart';

class TodoItem extends StatefulWidget {

  var _todo;
  var _index;

  TodoItem(var todo, var index){
    this._todo = todo;
    this._index = index;
  }

  @override
  _TodoItemState createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
          key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
          background: Container(
          color: Colors.red,
          child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white,),
          ),
        ),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction){
          deleteTodo(widget._todo["id"]).then(
              (response){
              }
          );
    },
    child: CheckboxListTile(
        title: Text(widget._todo["name"]),
        value: widget._todo["done"],
        onChanged: (done){
          doneTodo(done, widget._todo["id"]).then(
                  (response){
                setState(() {
                  widget._todo["done"] = !widget._todo["done"];
                });
              }
          );
        },
        secondary: CircleAvatar(
          child: Icon(
              widget._todo["done"] ? Icons.check : Icons.error
          ),
        ),
      )
    );
  }

  Future deleteTodo(id)async{
    http.Response response = await http.delete("${EndPoint.URL}/${id}");
    return response;
  }

  Future doneTodo(done, id) async {
    http.Response response = await http.put("${EndPoint.URL}/${id}?done=${done}");
    return response;
  }

}