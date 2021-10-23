import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tai_chi_intervention.g.dart';

@JsonSerializable()
class TaiChiIntervention extends Equatable {
  final String id;
  final String userId;
  final List<String> lessonsDone;
  final List<String> lessonsToDo;
  final int startTimestamp;
  final int? endTimestamp;
  final int earnedPoints;

  const TaiChiIntervention({
    required this.id,
    required this.userId,
    required this.lessonsDone,
    required this.lessonsToDo,
    required this.startTimestamp,
    this.endTimestamp,
    required this.earnedPoints,
  });

  factory TaiChiIntervention.fromJson(Map<String, dynamic> json) =>
      _$TaiChiInterventionFromJson(json);

  Map<String, dynamic> toJson() => _$TaiChiInterventionToJson(this);

  @override
  List<Object?> get props => [
        id,
        userId,
        lessonsDone,
        lessonsToDo,
        startTimestamp,
        endTimestamp,
        earnedPoints,
      ];

  TaiChiIntervention copyWith({
    String? id,
    String? userId,
    List<String>? lessonsDone,
    List<String>? lessonsToDo,
    int? startTimestamp,
    int? endTimestamp,
    int? earnedPoints,
  }) {
    return TaiChiIntervention(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      lessonsDone: lessonsDone ?? this.lessonsDone,
      lessonsToDo: lessonsToDo ?? this.lessonsToDo,
      startTimestamp: startTimestamp ?? this.startTimestamp,
      endTimestamp: endTimestamp ?? this.endTimestamp,
      earnedPoints: earnedPoints ?? this.earnedPoints,
    );
  }
}
