// USER
class User {
  int id;
  String name;
  int age;
  double height;
  double weight;

  User({
    required this.id,
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      height: json['height'],
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'height': height,
        'weight': weight,
      };

  // Method to calculate BMI
  double calculateBMI() {
    return weight / ((height / 100) * (height / 100)); // Convert height from cm to m
  }
}
