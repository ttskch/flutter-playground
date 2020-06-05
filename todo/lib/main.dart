import 'package:flutter/material.dart';

const String appTitle = 'Todo List';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  List<String> _todoItems = [];

  void _addTodoItem() {
    setState(() {
      final int index = _todoItems.length;
      _todoItems.add('Item $index');
    });
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        if (index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index]);
        }
        return null; // cannot be void
      },
    );
  }

  Widget _buildTodoItem(String todoText) {
    return ListTile(
      title: Text(todoText)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle)
      ),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodoItem,
        tooltip: 'Add task',
        child: Icon(Icons.add),
      )
    );
  }
}
