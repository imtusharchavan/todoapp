import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todoapp/models/todo.dart';

class DataStorage {
  static final DataStorage instance = DataStorage._internal();

  factory DataStorage() {
    return instance;
  }

  DataStorage._internal() {
    // initialization logic
    
    // Load the todo file
    _loadTodoFile();
  }
  
  // Variables for encryption and decryption
  static final Key key = Key.fromBase64("q5Yy9hkTRhf6cfkBW47sF3eqTneMkGM"); // This is your key, you can use whatever you want
  static final Encrypter encrypter = Encrypter(AES(key));
  static final IV iv = IV.fromLength(16);
  
  // Your todo file
  File todoStorage = File("");

  Future _loadTodoFile() async {
    todoStorage = File(
      "${(await getApplicationDocumentsDirectory()).path}/todos.json",
    );
  }

  Future<void> saveTodos(List<ToDo> todos) async {
    // Create a list for all todos to save them
    List<String> encryptedTodos = List.generate(
      todos.length,
      (index) => jsonEncode(todos[index].toEncryptJson(encrypter, iv)),
    );
    
    // Write to the file
    todoStorage.writeAsStringSync('{"todos": $encryptedTodos}');
  }
}