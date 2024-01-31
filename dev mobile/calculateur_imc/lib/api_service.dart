import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getIMCCategories() async {
  final response = await http.get(Uri.parse('your_api_endpoint_here'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load IMC categories');
  }

  
}
String getBMICategory(double bmi) {
  if (bmi < 18.5) {
    return 'Underweight';
  } else if (bmi >= 18.5 && bmi < 24.9) {
    return 'Normal Weight';
  } else if (bmi >= 25 && bmi < 29.9) {
    return 'Overweight';
  } else {
    return 'Obese';
  }
}

