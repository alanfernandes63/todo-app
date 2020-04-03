import 'package:flutter/material.dart';
import 'list.dart';

void main() async{
  //http.Response response = await http.get(endpoint);
  //print(json.decode(response.body));
  //print(response.body);
  runApp(MaterialApp(
    home: ListTodos(),
  ));
}