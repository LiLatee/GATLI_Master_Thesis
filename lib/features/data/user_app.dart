import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserApp extends Equatable {
  const UserApp({
    required this.id,
    required this.nickname,
    required this.email,
    required this.badgesKeys,
    required this.steps,
    required this.kilometers,
    required this.emojiSVG,
  });

  final String? id;
  final String nickname;
  final String email;
  final List<String> badgesKeys;
  final int steps;
  final int kilometers;
  final String emojiSVG;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nickname': nickname,
      'email': email,
      'badgesKeys': badgesKeys,
      'steps': steps,
      'kilometers': kilometers,
      'emojiSVG': emojiSVG,
    };
  }

  factory UserApp.fromMap(Map<String, dynamic> map) {
    return UserApp(
      id: map['id'],
      nickname: map['nickname'],
      email: map['email'],
      badgesKeys: List<String>.from(map['badgesKeys']),
      steps: map['steps'],
      kilometers: map['kilometers'],
      emojiSVG: map['emojiSVG'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserApp.fromJson(String source) =>
      UserApp.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
        id,
        nickname,
        email,
        badgesKeys,
        steps,
        kilometers,
        emojiSVG,
      ];

  UserApp copyWith({
    String? id,
    String? nickname,
    String? email,
    List<String>? badgesKeys,
    int? steps,
    int? kilometers,
    String? emojiSVG,
  }) {
    return UserApp(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      badgesKeys: badgesKeys ?? this.badgesKeys,
      steps: steps ?? this.steps,
      kilometers: kilometers ?? this.kilometers,
      emojiSVG: emojiSVG ?? this.emojiSVG,
    );
  }
}
