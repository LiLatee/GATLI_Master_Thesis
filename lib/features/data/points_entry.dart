import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'points_entry.g.dart';

@JsonSerializable()
class PointsEntry extends Equatable {
  final String reasonKey;
  final int points;
  final String title;
  final DateTime? datetime;

  const PointsEntry({
    required this.reasonKey,
    required this.points,
    required this.title,
    this.datetime,
  });

  factory PointsEntry.fromJson(Map<String, dynamic> json) =>
      _$PointsEntryFromJson(json);

  Map<String, dynamic> toJson() => _$PointsEntryToJson(this);
  @override
  List<Object?> get props => [
        reasonKey,
        datetime,
        points,
        title,
      ];

  PointsEntry copyWith({
    String? reasonKey,
    int? points,
    String? title,
    DateTime? datetime,
  }) {
    return PointsEntry(
      reasonKey: reasonKey ?? this.reasonKey,
      points: points ?? this.points,
      title: title ?? this.title,
      datetime: datetime ?? this.datetime,
    );
  }
}

abstract class PredefinedEntryPoints {
  static const taiChiSingleVideo = PointsEntry(
    reasonKey: 'taiChiSingleVideo',
    points: 10,
    title: 'Watched Tha Chi lesson',
  );

  static const taiChiWholeCourse = PointsEntry(
    reasonKey: 'taiChiSingleVideo',
    points: 100,
    title: 'Watched Tha Chi whole course',
  );

  static const activityXMins = PointsEntry(
    reasonKey: 'activityXMins',
    points: 1,
    title: 'Activity performed',
  );

  static const activityAbove30Mins = PointsEntry(
    reasonKey: 'activityAbove30Mins',
    points: 50,
    title: 'Activity above 30 minutes performed',
  );

  static const questionnaireDone = PointsEntry(
    reasonKey: 'questionnaireDone',
    points: 500,
    title: 'Filled questionnaire',
  );
}
