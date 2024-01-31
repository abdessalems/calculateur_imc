import 'package:calculateur_imc/api_service.dart';
import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  double bmiResult = 0.0;
  String bmiCategory = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IMC Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
            ),
            TextFormField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Height (m)'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                calculateBMI();
              },
              child: Text('Calculate'),
            ),
            SizedBox(height: 16),
            Text('BMI Result: $bmiResult'),
            Text('Category: $bmiCategory'),
          ],
        ),
      ),
    );
  }

  void calculateBMI() {
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double height = double.tryParse(heightController.text) ?? 0.0;

    double bmi = weight / (height * height);
    String category = getBMICategory(bmi);

    setState(() {
      bmiResult = bmi;
      bmiCategory = category;
    });
  }
}
