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
                itemBuilder: buildItem),
          )
        ],
      )
    );
  }

  Future getTodos()async {
    http.Response response = await http.get("${url}?type=all");
    return json.decode(response.body);
  }

  Future addTodo()async{
    var todo = json.encode({"name":_todoController.text, "done":false});
    var response = await http.post(url, body: todo, headers: {"Content-type": "application/json"});
    return json.decode(response.body);
  }

  Future doneTodo(done, id) async {
    http.Response response = await http.put("${url}/${id}?done=${done}");
    return response;
  }
  
  Future deleteTodo(id)async{
    http.Response response = await http.delete("${url}/${id}");
    return response;
  }
  Widget buildItem(context, index){
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
          deleteTodo(todoList[index]["id"]).then(
              (response){
                print(response.statusCode);
              }
          );
    },
    child: CheckboxListTile(
        title: Text(todoList[index]["name"]),
        value: todoList[index]["done"],
        onChanged: (done){
          doneTodo(done, todoList[index]["id"]).then(
                  (response){
                print(response.statusCode == 200);
                setState(() {
                  todoList[index]["done"] = !todoList[index]["done"];
                });
              }
          );
        },
        secondary: CircleAvatar(
          child: Icon(
              todoList[index]["done"] ? Icons.check : Icons.error
          ),
        ),
      )
    );
  }
}
