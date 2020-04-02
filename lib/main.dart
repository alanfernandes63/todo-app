import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import "dart:convert";
import 'list.dart';

const endpoint = "https://viacep.com.br/ws/RS/Porto%20Alegre/Domingos/json/";

void main() async{
  http.Response response = await http.get(endpoint);
  print(json.decode(response.body));
  print(response.body);
  runApp(MaterialApp(
    home: ListTodos(),
  ));
}