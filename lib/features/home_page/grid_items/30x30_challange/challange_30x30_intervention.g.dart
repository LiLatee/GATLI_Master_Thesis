// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challange_30x30_intervention.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Challange30x30Intervention _$Challange30x30InterventionFromJson(
        Map<String, dynamic> json) =>
    Challange30x30Intervention(
      userId: json['userId'] as String,
      id: json['id'] as String,
      startDatetime: DateTime.parse(json['startDatetime'] as String),
      endDatetime: DateTime.parse(json['endDatetime'] as String),
      days: (json['days'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k,
            e == null
                ? null
                : ChallangeOneDayStats.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$Challange30x30InterventionToJson(
        Challange30x30Intervention instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'id': instance.id,
      'startDatetime': instance.startDatetime.toIso8601String(),
      'endDatetime': instance.endDatetime.toIso8601String(),
      'days': instance.days?.map((k, e) => MapEntry(k, e?.toJson())),
    };
