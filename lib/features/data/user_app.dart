import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:master_thesis/features/data/points_entry.dart';
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
    this.pointsEntries = const [],
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
  final List<PointsEntry> pointsEntries;

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
        pointsEntries,
      ];

  factory UserApp.fromJson(Map<String, dynamic> json) =>
      _$UserAppFromJson(json);

  Map<String, dynamic> toJson() => _$UserAppToJson(this);

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
    List<PointsEntry>? pointsEntries,
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
      pointsEntries: pointsEntries ?? this.pointsEntries,
    );
  }
}
