import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    this.id,
    this.reference,
    required this.nickname,
    required this.email,
    required this.badgesKeys,
    required this.steps,
    required this.kilometers,
  });

  String? id;
  DocumentReference? reference;
  final String nickname;
  final String email;
  final List<String> badgesKeys;
  final int steps;
  final int kilometers;

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'email': email,
      'badgesKeys': badgesKeys,
      'steps': steps,
      'kilometers': kilometers,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      nickname: map['nickname'],
      email: map['email'],
      badgesKeys: List<String>.from(map['badgesKeys']),
      steps: map['steps'],
      kilometers: map['kilometers'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
