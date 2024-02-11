class BMICalculator {
  static double calculateBMI(double weight, double height) {
    // Convert height from centimeters to meters
    double heightInMeters = height / 100;
    // Calculate BMI
    return weight / (heightInMeters * heightInMeters);
  }
}
