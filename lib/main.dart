import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'models/task_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      home: TaskScreen(),
    );
  }
}

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _status = 'Pending';
  final List<String> _statusOptions = ['On Progress', 'Pending', 'Done'];
  final List<Task> _tasks = [];
  final Uuid _uuid = Uuid();
  String _filterStatus = 'All';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Task newTask = Task(id: _uuid.v4(), title: _title, status: _status);
      setState(() {
        _tasks.add(newTask);
      });
      _formKey.currentState!.reset();
    }
  }

  void _setFilterStatus(String status) {
    setState(() {
      _filterStatus = status;
    });
  }

  void _removeTask(String id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
  }

  void _editTask(Task task) {
    _title = task.title;
    _status = task.status;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: task.title,
                  decoration: InputDecoration(labelText: 'Title'),
                  onSaved: (value) {
                    _title = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Status'),
                  value: _status,
                  onChanged: (value) {
                    setState(() {
                      _status = value as String;
                    });
                  },
                  items: _statusOptions.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  setState(() {
                    task.git title = _title;
                    task.status = _status;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  List<Task> _getFilteredTasks() {
    if (_filterStatus == 'All') {
      return _tasks;
    } else {
      return _tasks.where((task) => task.status == _filterStatus).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Title'),
                    onSaved: (value) {
                      _title = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(labelText: 'Status'),
                    value: _status,
                    onChanged: (value) {
                      setState(() {
                        _status = value as String;
                      });
                    },
                    items: _statusOptions.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Add Task'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _filterStatus == 'All' ? Colors.white70 : Colors.white,
                  ),
                  onPressed: () => _setFilterStatus('All'),
                  child: Text('All'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _filterStatus == 'On Progress' ? Colors.white70 : Colors.white,
                  ),
                  onPressed: () => _setFilterStatus('On Progress'),
                  child: Text('On Progress'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _filterStatus == 'Pending' ? Colors.white70 : Colors.white,
                  ),
                  onPressed: () => _setFilterStatus('Pending'),
                  child: Text('Pending'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _filterStatus == 'Done' ? Colors.white70 : Colors.white,
                  ),
                  onPressed: () => _setFilterStatus('Done'),
                  child: Text('Done'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _getFilteredTasks().length,
                itemBuilder: (context, index) {
                  var task = _getFilteredTasks()[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(task.status),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.grey),
                            onPressed: () => _editTask(task),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeTask(task.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
