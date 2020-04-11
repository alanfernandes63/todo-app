import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "dart:convert";
import 'dart:async';
import 'todoItem.dart';
import 'endpoints.dart';

class ListTodos extends StatefulWidget {
  @override
  _ListTodosState createState() => _ListTodosState();
}

class _ListTodosState extends State<ListTodos> {
  var todoList = [];
  final _todoController = TextEditingController();
  var _loading = true;

  @override
  void initState(){
    super.initState();
    getTodos().then((map){
      setState(() {
        todoList = map;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Todos"),),
    body:Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child:Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      labelText: "Nova tarefa"
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: (){
                    addTodo().then((map){
                      setState(() {
                        todoList.add(map);
                        _todoController.text = "";
                      });
                    });
                  },
                ),
              ],
            ),
          ),
          _loading ? Container(
              padding: EdgeInsets.only(top: 100.0),
              child: Center(child: CircularProgressIndicator())):
          Expanded(
            child:ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) =>TodoItem(todoList[index], index)),
          )
        ],
      )
    );
  }

  Future getTodos()async {
    http.Response response = await http.get("${EndPoint.URL}?type=all");
    return json.decode(response.body);
  }

  Future addTodo()async{
    setState(() {
      _loading = true;
    });
    var todo = json.encode({"name":_todoController.text, "done":false});
    var response = await http.post(EndPoint.URL, body: todo, headers: {"Content-type": "application/json"});
    setState(() {
      _loading =false;
    });
    return json.decode(response.body);
  }  
}
