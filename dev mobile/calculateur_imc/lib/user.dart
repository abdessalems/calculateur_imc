class User {
  String id; // Change the type of 'id' to String
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

  // Copy constructor
  User.fromUser(User user)
      : id = user.id,
        name = user.name,
        age = user.age,
        height = user.height,
        weight = user.weight;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(), // Ensure 'id' is stored as a string
      name: json['name'] as String,
      age: json['age'] as int,
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
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
    return weight /
        ((height / 100) * (height / 100)); // Convert height from cm to m
  }
}
