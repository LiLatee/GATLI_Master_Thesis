import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'challenge_one_day_stats.g.dart';

@JsonSerializable()
class ChallengeOneDayStats extends Equatable {
  final DateTime day;
  final int steps;
  final int minutesOfMove;

  const ChallengeOneDayStats({
    required this.day,
    required this.steps,
    required this.minutesOfMove,
  });

  @override
  List<Object?> get props => [
        day,
        steps,
        minutesOfMove,
      ];

  factory ChallengeOneDayStats.fromJson(Map<String, dynamic> json) =>
      _$ChallangeOneDayStatsFromJson(json);

  Map<String, dynamic> toJson() => _$ChallangeOneDayStatsToJson(this);

  ChallengeOneDayStats copyWith({
    DateTime? day,
    int? steps,
    int? minutesOfMove,
  }) {
    return ChallengeOneDayStats(
      day: day ?? this.day,
      steps: steps ?? this.steps,
      minutesOfMove: minutesOfMove ?? this.minutesOfMove,
    );
  }
}
