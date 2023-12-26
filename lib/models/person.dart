import 'dart:convert';

class Person {
  final String firstName;
  final String lastName;
  final String photoUrl;
  final String email;
  final String createdAt;
  final String userId;
  final bool discoverable;

  String get username => '${firstName.toLowerCase()}.${lastName.toLowerCase()}';

  Person({
    required this.firstName,
    required this.lastName,
    required this.photoUrl,
    required this.email,
    required this.createdAt,
    required this.userId,
    required this.discoverable,
  });

  Person copyWith({
    String? firstName,
    String? lastName,
    String? photoUrl,
    String? email,
    String? createdAt,
    String? userId,
    bool? discoverable,
  }) =>
      Person(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        photoUrl: photoUrl ?? this.photoUrl,
        email: email ?? this.email,
        createdAt: createdAt ?? this.createdAt,
        userId: userId ?? this.userId,
        discoverable: discoverable ?? this.discoverable,
      );

  factory Person.fromRawJson(String str) => Person.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        firstName: json["first_name"],
        lastName: json["last_name"],
        photoUrl: json["photoUrl"],
        email: json["email"],
        createdAt: json["created_at"],
        userId: json["user_id"],
        discoverable: json["discoverable"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "photoUrl": photoUrl,
        "email": email,
        "created_at": createdAt,
        "user_id": userId,
        "discoverable": discoverable,
      };
}
