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
  static const thaiChiSingleVideo = PointsEntry(
      reasonKey: 'thaiChiSingleVideo',
      points: 10,
      title: 'Watched Tha Chi lesson');

  static const thaiChiWholeCourse = PointsEntry(
      reasonKey: 'thaiChiSingleVideo',
      points: 10,
      title: 'Watched Tha Chi whole course');
}
