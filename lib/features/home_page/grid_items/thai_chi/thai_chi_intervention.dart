import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'thai_chi_intervention.g.dart';

@JsonSerializable()
class ThaiChiIntervention extends Equatable {
  final String id;
  final String userId;
  final List<String> lessonsDone;
  final List<String> lessonsToDo;
  final int startTimestamp;
  final int? endTimestamp;
  final int earnedPoints;

  const ThaiChiIntervention({
    required this.id,
    required this.userId,
    required this.lessonsDone,
    required this.lessonsToDo,
    required this.startTimestamp,
    this.endTimestamp,
    required this.earnedPoints,
  });

  factory ThaiChiIntervention.fromJson(Map<String, dynamic> json) =>
      _$ThaiChiInterventionFromJson(json);

  Map<String, dynamic> toJson() => _$ThaiChiInterventionToJson(this);

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

  ThaiChiIntervention copyWith({
    String? id,
    String? userId,
    List<String>? lessonsDone,
    List<String>? lessonsToDo,
    int? startTimestamp,
    int? endTimestamp,
    int? earnedPoints,
  }) {
    return ThaiChiIntervention(
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
