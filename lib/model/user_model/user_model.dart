class UserModel {
  final userId;
  final name;
  final email;

  UserModel({
    this.userId,
    this.name,
    this.email,
  });

  factory UserModel.fromJson(Map<dynamic, dynamic> parseJson) {
    return UserModel(
      userId: parseJson['userId'],
      name: parseJson['name'],
      email: parseJson['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "name": name,
      "email": email,
    };
  }
}
