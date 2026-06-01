import 'package:flutter/foundation.dart';

class AuthUser {
  final int id;
  final String email;
  final String name;
  final String? picture;

  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
    this.picture,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as int,
        email: json['email'] as String,
        name: json['name'] as String,
        picture: json['picture'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'picture': picture,
      };
}

final authNotifier = ValueNotifier<AuthUser?>(null);
