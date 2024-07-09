import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

  class _HomePageState extends State<HomePage> {
    final _taskNameController = TextEditingController();
    List<String> _taskList = [];

    @override
    void initState() {
      super.initState();
      _loadTask();
    }

    Future<void> _loadTask() async {
      final sp = await SharedPreferences.getInstance();
      _taskList = sp.getStringList("tasks") ?? [];
    }

    Future<void> _deleteTask(int index) async {
      setState(() {
        _taskList.removeAt(index);
      });
    }

    Future<void> _addTask() async {
      if (_taskNameController.text.isNotEmpty) {
        final sp = await SharedPreferences.getInstance();
        setState(() {
          _taskList.add(_taskNameController.text);
          _taskNameController.clear();
          sp.setStringList("tasks", _taskList);
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("To-do list")
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _taskNameController,
                      decoration: const InputDecoration(
                        labelText: 'Enter Task',
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: _addTask,
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(child: ListView.builder(
                  itemCount: _taskList.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child:
                          ListTile(
                            title: Text(_taskList[index]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteTask(index),
                            ),
                          )
                        );
                  }))
            ],
          ),
        ),
      );
    }
  }
