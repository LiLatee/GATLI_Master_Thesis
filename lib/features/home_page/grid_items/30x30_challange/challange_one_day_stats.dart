import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'challange_one_day_stats.g.dart';

@JsonSerializable()
class ChallangeOneDayStats extends Equatable {
  final DateTime day;
  final int steps;
  final int minutesOfMove;

  const ChallangeOneDayStats({
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

  factory ChallangeOneDayStats.fromJson(Map<String, dynamic> json) =>
      _$ChallangeOneDayStatsFromJson(json);

  Map<String, dynamic> toJson() => _$ChallangeOneDayStatsToJson(this);

  ChallangeOneDayStats copyWith({
    DateTime? day,
    int? steps,
    int? minutesOfMove,
  }) {
    return ChallangeOneDayStats(
      day: day ?? this.day,
      steps: steps ?? this.steps,
      minutesOfMove: minutesOfMove ?? this.minutesOfMove,
    );
  }
}
