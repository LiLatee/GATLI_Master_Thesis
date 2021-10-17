// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_app.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApp _$UserAppFromJson(Map<String, dynamic> json) => UserApp(
      id: json['id'] as String?,
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      badgesKeys: (json['badgesKeys'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      steps: json['steps'] as int,
      kilometers: json['kilometers'] as int,
      emojiSVG: json['emojiSVG'] as String,
      activeInterventions:
          (json['activeInterventions'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
      pastInterventions:
          (json['pastInterventions'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
      activitySessions: (json['activitySessions'] as List<dynamic>?)
              ?.map((e) => ActivitySession.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pointsEntries: (json['pointsEntries'] as List<dynamic>?)
              ?.map((e) => PointsEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserAppToJson(UserApp instance) => <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'email': instance.email,
      'badgesKeys': instance.badgesKeys,
      'steps': instance.steps,
      'kilometers': instance.kilometers,
      'emojiSVG': instance.emojiSVG,
      'activeInterventions': instance.activeInterventions,
      'pastInterventions': instance.pastInterventions,
      'activitySessions':
          instance.activitySessions.map((e) => e.toJson()).toList(),
      'pointsEntries': instance.pointsEntries.map((e) => e.toJson()).toList(),
    };
