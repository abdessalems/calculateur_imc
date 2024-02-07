import 'package:flutter/material.dart';
import 'package:calculateur_imc/api_service.dart';
import 'package:calculateur_imc/user.dart';
import 'package:calculateur_imc/bmi_calculator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late APIService _apiService;
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _apiService = APIService();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      List<User> users = await _apiService.getUsers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      print('Error loading users: $e');
    }
  }

  Future<void> _addUser(User user) async {
    try {
      await _apiService.createUser(user);
      _loadUsers();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _updateUser(User user) async {
    try {
      await _apiService.updateUser(user);
      _loadUsers();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _deleteUser(int id) async {
  try {
    await _apiService.deleteUser(id);
    setState(() {
      _users.removeWhere((user) => user.id == id);
    });
  } catch (e) {
    // Handle error
    print('Error deleting user: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_users[index].name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Age: ${_users[index].age}'),
                Text('Height: ${_users[index].height} cm'),
                Text('Weight: ${_users[index].weight} kg'),
                Text('BMI: ${_calculateBMI(_users[index]) ?? 'N/A'}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editUser(_users[index]);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteUser(_users[index].id);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addUserDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _addUserDialog() async {
    User newUser = User(id: 0, name: '', age: 0, height: 0, weight: 0);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  newUser.name = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  newUser.age = int.parse(value);
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Height'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  newUser.height = double.parse(value);
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Weight'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  newUser.weight = double.parse(value);
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addUser(newUser);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  double? _calculateBMI(User user) {
    if (user.height != null && user.weight != null) {
      return BMICalculator.calculateBMI(user.weight!, user.height!);
    }
    return null;
  }

 
 Future<void> _editUser(User user) async {
  User editedUser = user;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
              controller: TextEditingController(text: editedUser.name),
              onChanged: (value) {
                setState(() {
                  editedUser.name = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: editedUser.age.toString()),
              onChanged: (value) {
                setState(() {
                  editedUser.age = int.parse(value);
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Height'),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: editedUser.height.toString()),
              onChanged: (value) {
                setState(() {
                  editedUser.height = double.parse(value);
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Weight'),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: editedUser.weight.toString()),
              onChanged: (value) {
                setState(() {
                  editedUser.weight = double.parse(value);
                });
              },
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _updateUser(editedUser);
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}

}
