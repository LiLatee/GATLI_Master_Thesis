// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointsEntry _$PointsEntryFromJson(Map<String, dynamic> json) => PointsEntry(
      reasonKey: json['reasonKey'] as String,
      points: json['points'] as int,
      title: json['title'] as String,
      datetime: json['datetime'] == null
          ? null
          : DateTime.parse(json['datetime'] as String),
    );

Map<String, dynamic> _$PointsEntryToJson(PointsEntry instance) =>
    <String, dynamic>{
      'reasonKey': instance.reasonKey,
      'points': instance.points,
      'title': instance.title,
      'datetime': instance.datetime?.toIso8601String(),
    };
