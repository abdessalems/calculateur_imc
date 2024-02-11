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
  String _nextId = '1'; // Initialize the ID counter as a string

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
      // Find the highest ID among the loaded users
      int maxId = _users.fold(
        0,
        (prev, user) {
          try {
            int userId = int.parse(user.id);
            return userId > prev ? userId : prev;
          } catch (_) {
            return prev;
          }
        },
      );

      // Increment the next ID counter to one greater than the highest ID
      _nextId = (maxId + 1).toString();
    } catch (e) {
      print('Error loading users: $e');
    }
  }

  Future<void> _addUser(User user) async {
    try {
      // Set the ID of the new user to the next available ID
      user.id = _nextId;
      await _apiService.createUser(user);
      _loadUsers();
      _nextId = (int.parse(_nextId) + 1)
          .toString(); // Increment the ID counter for the next user
    } catch (e) {
      print('Error adding user: $e');
    }
  }

  Future<void> _deleteUser(String id) async {
    try {
      await _apiService.deleteUser(int.parse(id));
      setState(() {
        _users.removeWhere((user) => user.id == id);
      });
    } on Exception catch (e) {
      print('Error deleting user: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          // Calculate BMI category for the user
          String bmiCategory = _calculateBMICategory(_users[index]);

          return ListTile(
            title: Text(_users[index].name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Age: ${_users[index].age}'),
                Text('Height: ${_users[index].height} cm'),
                Text('Weight: ${_users[index].weight} kg'),
                Text('BMI: ${_calculateBMI(_users[index]) ?? 'N/A'}'),
                Text('BMI Category: $bmiCategory'),
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
    User newUser = User(id: '0', name: '', age: 0, height: 0, weight: 0);
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

  Future<void> _editUser(User user) async {
    // Create a copy of the user to edit
    User editedUser = User.fromUser(user);

    // Controllers to track changes in the fields
    TextEditingController nameController =
        TextEditingController(text: editedUser.name);
    TextEditingController ageController =
        TextEditingController(text: editedUser.age.toString());
    TextEditingController heightController =
        TextEditingController(text: editedUser.height.toString());
    TextEditingController weightController =
        TextEditingController(text: editedUser.weight.toString());

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit User'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Name'),
                    controller: nameController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    controller: ageController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Height'),
                    keyboardType: TextInputType.number,
                    controller: heightController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Weight'),
                    keyboardType: TextInputType.number,
                    controller: weightController,
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
                    // Update the user with the edited values
                    editedUser.name = nameController.text;
                    editedUser.age = int.parse(ageController.text);
                    editedUser.height = double.parse(heightController.text);
                    editedUser.weight = double.parse(weightController.text);
                    _updateUser(editedUser);
                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Method to calculate BMI category based on BMI value
  String _calculateBMICategory(User user) {
    if (user.height != null && user.weight != null) {
      double bmi = BMICalculator.calculateBMI(user.weight!, user.height!);
      return _getBMICategory(bmi);
    }
    return 'N/A';
  }

  // Method to get BMI category label
  String _getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 24.9) {
      return 'Healthy Weight';
    } else if (bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obesity';
    }
  }

  String _calculateBMI(User user) {
    if (user.height != null && user.weight != null) {
      double bmi = BMICalculator.calculateBMI(user.weight!, user.height!);
      return bmi.toStringAsFixed(2); // Limit to 2 decimal places
    }
    return 'N/A';
  }
}
