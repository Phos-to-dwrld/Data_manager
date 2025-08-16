import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const StudentManagementApp());
}

class StudentManagementApp extends StatelessWidget {
  const StudentManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management System',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _command = '';
  final TextEditingController _commandController = TextEditingController();
  String _output = 'Welcome to the Data Bank!\n'
      'Enter a command: search, add, load, delete, directory, update, export, terminate';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Management System')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _commandController,
              decoration: const InputDecoration(
                labelText: 'Enter command',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) => _handleCommand(value),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_output, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCommand(String command) async {
    setState(() {
      _command = command.toLowerCase();
      _commandController.clear();
    });

    if (_command == 'directory') {
      setState(() {
        _output = '''
        Welcome to the Data Bank!
        What would you like to do?
        search   : to search for a student
        add      : to add a student's info
        load     : to get the class info
        delete   : to delete a student's info
        directory: to get the command list
        update   : to edit a student's info
        export   : to save all students' info into one file
        terminate: to exit
        ''';
      });
    } else if (_command == 'search') {
      _showSearchDialog();
    } else if (_command == 'add') {
      _showAddDialog();
    } else if (_command == 'load') {
      _showLoadDialog();
    } else if (_command == 'delete') {
      _showDeleteDialog();
    } else if (_command == 'update') {
      _showUpdateDialog();
    } else if (_command == 'export') {
      await _exportAllStudents();
    } else if (_command == 'terminate') {
      setState(() {
        _output = 'Exiting... (In a web app, this just resets)';
      });
    } else {
      setState(() {
        _output = 'Invalid command...';
      });
    }
  }

  Future<Map<String, List<String>>> _loadStudents(String className) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(className) ?? '{}';
    return Map<String, List<String>>.from(
        json.decode(data).map((k, v) => MapEntry(k, List<String>.from(v))));
  }

  Future<void> _saveStudents(Map<String, List<String>> data, String className) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(className, json.encode(data));
  }

  void _showSearchDialog() {
    String name = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Student'),
        content: TextField(
          decoration: const InputDecoration(labelText: 'Student Name'),
          onChanged: (value) => name = value,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _searchStudent(name);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  Future<void> _searchStudent(String name) async {
    List<String> fileList = ['jss1.json', 'jss2.json', 'jss3.json', 'ss1.json', 'ss2.json', 'ss3.json'];
    for (String file in fileList) {
      var data = await _loadStudents(file);
      if (data.containsKey(name)) {
        setState(() {
          _output = '''
          Searching...
          Name: $name
          Department: ${data[name]![0]}
          Age: ${data[name]![1]}
          No of subjects: ${data[name]![2]}
          Disabilities: ${data[name]![3]}
          Student Rank: ${data[name]![4]}
          ''';
        });
        return;
      }
    }
    setState(() {
      _output = 'Name not found.';
    });
  }

  void _showAddDialog() {
    String className = '';
    String name = '';
    String department = '';
    String age = '';
    String subjects = '';
    String disability = '';
    String rank = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Student'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Class (e.g., jss1.json)'),
                onChanged: (value) => className = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Student Name'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Department'),
                onChanged: (value) => department = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Age'),
                onChanged: (value) => age = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'No of Subjects'),
                onChanged: (value) => subjects = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Disability'),
                onChanged: (value) => disability = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Rank'),
                onChanged: (value) => rank = value,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              var data = await _loadStudents(className);
              data[name] = [department, age, subjects, disability, rank];
              await _saveStudents(data, className);
              setState(() {
                _output = 'Student added successfully!';
              });
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showLoadDialog() {
    String className = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Load Class'),
        content: TextField(
          decoration: const InputDecoration(labelText: 'Class (e.g., jss1.json)'),
          onChanged: (value) => className = value,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              var data = await _loadStudents(className);
              String result = 'Class Info:\n';
              data.forEach((name, details) {
                result += '''
                Name: $name
                Department: ${details[0]}
                Age: ${details[1]}
                No of subjects: ${details[2]}
                Disabilities: ${details[3]}
                Student Rank: ${details[4]}\n
                ''';
              });
              setState(() {
                _output = result.isNotEmpty ? result : 'No students found.';
              });
            },
            child: const Text('Load'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    String className = '';
    String name = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Class (e.g., jss1.json)'),
              onChanged: (value) => className = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Student Name'),
              onChanged: (value) => name = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              var data = await _loadStudents(className);
              if (data.containsKey(name)) {
                data.remove(name);
                await _saveStudents(data, className);
                setState(() {
                  _output = 'Student deleted successfully!';
                });
              } else {
                setState(() {
                  _output = 'Name not found.';
                });
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog() {
    String className = '';
    String name = '';
    String department = '';
    String age = '';
    String subjects = '';
    String disability = '';
    String rank = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Student'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Class (e.g., jss1.json)'),
                onChanged: (value) => className = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Student Name'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'New Department'),
                onChanged: (value) => department = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'New Age'),
                onChanged: (value) => age = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'New No of Subjects'),
                onChanged: (value) => subjects = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'New Disability'),
                onChanged: (value) => disability = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'New Rank'),
                onChanged: (value) => rank = value,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              var data = await _loadStudents(className);
              if (data.containsKey(name)) {
                data[name] = [department, age, subjects, disability, rank];
                await _saveStudents(data, className);
                setState(() {
                  _output = 'Student information updated successfully!';
                });
              } else {
                setState(() {
                  _output = 'Student not found.';
                });
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportAllStudents() async {
    List<String> fileList = ['jss1.json', 'jss2.json', 'jss3.json', 'ss1.json', 'ss2.json', 'ss3.json'];
    Map<String, List<String>> allStudents = {};
    for (String file in fileList) {
      var data = await _loadStudents(file);
      allStudents.addAll(data);
    }
    await _saveStudents(allStudents, 'all_students.json');
    setState(() {
      _output = 'All student data exported to all_students.json';
    });
  }
}
