import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMC Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double weight = 0.0;
  double height = 0.0;
  double bmi = 0.0;
  String bmiCategory = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IMC Calculator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter Weight (kg)'),
              onChanged: (value) {
                setState(() {
                  weight = double.parse(value);
                });
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter Height (m)'),
              onChanged: (value) {
                setState(() {
                  height = double.parse(value);
                });
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                calculateBMI();
                fetchIMCCategories(); // Call this method if you want to fetch IMC categories from an API
              },
              child: Text('Calculate BMI'),
            ),
            SizedBox(height: 20.0),
            Text('BMI: $bmi'),
            Text('Category: $bmiCategory'),
          ],
        ),
      ),
    );
  }

  void calculateBMI() {
    setState(() {
      bmi = weight / (height * height);
      // Logic to categorize BMI
      if (bmi < 18.5) {
        bmiCategory = 'Underweight';
      } else if (bmi >= 18.5 && bmi < 25) {
        bmiCategory = 'Normal';
      } else if (bmi >= 25 && bmi < 30) {
        bmiCategory = 'Overweight';
      } else {
        bmiCategory = 'Obese';
      }
    });
  }

  Future<void> fetchIMCCategories() async {
    try {
      final response = await http.get(Uri.parse('your_api_endpoint_here'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Process the data if needed
      } else {
        throw Exception('Failed to load IMC categories');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
