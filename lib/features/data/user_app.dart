import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:master_thesis/features/home_page/grid_items/activity/activity_session.dart';
part 'user_app.g.dart';

@JsonSerializable(explicitToJson: true)
class UserApp extends Equatable {
  const UserApp({
    required this.id,
    required this.nickname,
    required this.email,
    required this.badgesKeys,
    required this.steps,
    required this.kilometers,
    required this.emojiSVG,
    required this.activeInterventions,
    required this.pastInterventions,
    this.activitySessions = const [],
  });

  final String? id;
  final String nickname;
  final String email;
  final List<String> badgesKeys;
  final int steps;
  final int kilometers;
  final String emojiSVG;
  final Map<String, List<String>> activeInterventions;
  final Map<String, List<String>> pastInterventions;
  final List<ActivitySession> activitySessions;

  @override
  List<Object?> get props => [
        id,
        nickname,
        email,
        badgesKeys,
        steps,
        kilometers,
        emojiSVG,
        activeInterventions,
        pastInterventions,
        activitySessions,
      ];

  factory UserApp.fromJson(Map<String, dynamic> json) =>
      _$UserAppFromJson(json);

  Map<String, dynamic> toJson() => _$UserAppToJson(this);

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'nickname': nickname,
  //     'email': email,
  //     'badgesKeys': badgesKeys,
  //     'steps': steps,
  //     'kilometers': kilometers,
  //     'emojiSVG': emojiSVG,
  //     'activeInterventions': activeInterventions,
  //     'pastInterventions': pastInterventions,
  //   };
  // }

  // factory UserApp.fromMap(Map<String, dynamic> map) {
  //   log('kkkkk');
  //   log(map['activeInterventions'].toString());
  //   // log(jsonDecode(map['activeInterventions'].toString()).toString());
  //   return UserApp(
  //       id: map['id'],
  //       nickname: map['nickname'],
  //       email: map['email'],
  //       badgesKeys: List<String>.from(map['badgesKeys']),
  //       steps: map['steps'],
  //       kilometers: map['kilometers'],
  //       emojiSVG: map['emojiSVG'],
  //       activeInterventions: <String, List<String>>{
  //         'thai_chi': map['activeInterventions']['thai_chi'] as List<String>
  //       },
  //       pastInterventions: <String, List<String>>{
  //         'thai_chi': map['pastInterventions']['thai_chi'] as List<String>
  //       }
  //       // activeInterventions: Map<String, List<String>>.from(
  //       //     map['activeInterventions']),
  //       // pastInterventions: Map<String, List<String>>.from(
  //       //     map['pastInterventions']),
  //       );
  // }

  // String toJson() => json.encode(toMap());

  // factory UserApp.fromJson(String source) =>
  //     UserApp.fromMap(json.decode(source));

  UserApp copyWith({
    String? id,
    String? nickname,
    String? email,
    List<String>? badgesKeys,
    int? steps,
    int? kilometers,
    String? emojiSVG,
    Map<String, List<String>>? activeInterventions,
    Map<String, List<String>>? pastInterventions,
    List<ActivitySession>? activitySessions,
  }) {
    return UserApp(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      badgesKeys: badgesKeys ?? this.badgesKeys,
      steps: steps ?? this.steps,
      kilometers: kilometers ?? this.kilometers,
      emojiSVG: emojiSVG ?? this.emojiSVG,
      activeInterventions: activeInterventions ?? this.activeInterventions,
      pastInterventions: pastInterventions ?? this.pastInterventions,
      activitySessions: activitySessions ?? this.activitySessions,
    );
  }
}
