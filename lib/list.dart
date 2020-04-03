import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "dart:convert";
import 'dart:async';

const url = "https://tarefas-teste.herokuapp.com/api/v1/todos";
class ListTodos extends StatefulWidget {
  @override
  _ListTodosState createState() => _ListTodosState();
}

class _ListTodosState extends State<ListTodos> {
  var todoList = null;
  final _todoController = TextEditingController();

  void getTodos()async {
    var response = await http.get(url);
    todoList = json.decode(response.body);
    print(todoList);
  }
  
  void addTodo()async{

    var todo = json.encode({"name":_todoController.text, "done":false});
    print(todo);
    var response = await http.post(url, body: todo, headers: {"Content-type": "application/json"});
    print(response.statusCode);
  }

  @override
  void initState(){
    getTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todos"),),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
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
                  onPressed: addTodo,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (contex, index){
                  return CheckboxListTile(
                    title: Text(todoList[index]["name"]),
                    value: todoList[index]["done"],
                    secondary: CircleAvatar(
                      child: Icon(
                        todoList[index]["done"] ? Icons.check : Icons.error
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
