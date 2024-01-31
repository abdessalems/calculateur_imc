import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculateur d\'IMC',
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
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  double bmiResult = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculateur d\'IMC'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Poids (en kg)'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Taille (en m)'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                calculateBMI();
              },
              child: Text('Calculer l\'IMC'),
            ),
            SizedBox(height: 16.0),
            Text('IMC : ${bmiResult.toStringAsFixed(2)}'),
            SizedBox(height: 16.0),
            Text(getBMIStatus()),
          ],
        ),
      ),
    );
  }

  void calculateBMI() {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text);

    setState(() {
      bmiResult = weight / (height * height);
    });
  }

  String getBMIStatus() {
    if (bmiResult < 18.5) {
      return 'Insuffisance pondérale';
    } else if (bmiResult >= 18.5 && bmiResult < 24.9) {
      return 'Normal';
    } else if (bmiResult >= 25 && bmiResult < 29.9) {
      return 'Surpoids';
    } else {
      return 'Obésité';
    }
  }
}
