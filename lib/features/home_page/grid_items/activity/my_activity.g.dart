// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyActivity _$MyActivityFromJson(Map<String, dynamic> json) => MyActivity(
      isActive: json['isActive'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      durationInMinutes: json['durationInMinutes'] as int? ?? 0,
      type: _$enumDecodeNullable(_$MyActivityTypeEnumMap, json['type']),
      confidence: json['confidence'] as int?,
      isStart: json['isStart'] as bool? ?? false,
      isEnd: json['isEnd'] as bool? ?? false,
    );

Map<String, dynamic> _$MyActivityToJson(MyActivity instance) =>
    <String, dynamic>{
      'isActive': instance.isActive,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': _$MyActivityTypeEnumMap[instance.type],
      'confidence': instance.confidence,
      'isStart': instance.isStart,
      'isEnd': instance.isEnd,
      'durationInMinutes': instance.durationInMinutes,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$MyActivityTypeEnumMap = {
  MyActivityType.IN_VEHICLE: 'IN_VEHICLE',
  MyActivityType.ON_BICYCLE: 'ON_BICYCLE',
  MyActivityType.ON_FOOT: 'ON_FOOT',
  MyActivityType.RUNNING: 'RUNNING',
  MyActivityType.STILL: 'STILL',
  MyActivityType.TILTING: 'TILTING',
  MyActivityType.UNKNOWN: 'UNKNOWN',
  MyActivityType.WALKING: 'WALKING',
  MyActivityType.INVALID: 'INVALID',
};
