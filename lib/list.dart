import 'package:flutter/material.dart';

class ListTodos extends StatefulWidget {
  @override
  _ListTodosState createState() => _ListTodosState();
}

class _ListTodosState extends State<ListTodos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todos"),),
    );
  }
}
