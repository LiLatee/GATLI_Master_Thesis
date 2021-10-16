import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:master_thesis/features/home_page/grid_items/30x30_challange/challange_one_day_stats.dart';

part 'challange_30x30_intervention.g.dart';

@JsonSerializable(explicitToJson: true)
class Challange30x30Intervention extends Equatable {
  final String userId;
  final String id;
  final DateTime startDatetime;
  final DateTime endDatetime;
  late Map<String, ChallangeOneDayStats?>? days;

  Challange30x30Intervention({
    required this.userId,
    required this.id,
    required this.startDatetime,
    required this.endDatetime,
    this.days,
  }) {
    if (days == null) {
      final DateTime startDatetimeOnlyDay = DateTime.utc(
          startDatetime.year, startDatetime.month, startDatetime.day);
      days = {};
      for (int i = 0; i < 30; i++) {
        days![DateFormat('yyyy-MM-dd')
            .format(startDatetimeOnlyDay.add(Duration(days: i)))] = null;
      }
    }
  }

  Challange30x30Intervention.fakeData({
    required this.userId,
    required this.id,
    required this.startDatetime,
    required this.endDatetime,
    this.days,
  }) {
    final DateTime startDatetimeOnlyDay = DateTime.utc(
      startDatetime.year,
      startDatetime.month,
      startDatetime.day,
    );
    days = {};
    for (int i = 0; i < 30; i++) {
      // log('i: $i');
      // log(startDatetimeOnlyDay.add(Duration(days: i)).toString());
      days![DateFormat('yyyy-MM-dd')
              .format(startDatetimeOnlyDay.add(Duration(days: i)))] =
          ChallangeOneDayStats(
        day: DateTime.now().toUtc(),
        steps: 1234,
        minutesOfMove: 789,
      );
    }

    days![DateFormat('yyyy-MM-dd')
        .format(startDatetimeOnlyDay.add(Duration(days: 1)))] = null;
    days![DateFormat('yyyy-MM-dd')
        .format(startDatetimeOnlyDay.add(Duration(days: 10)))] = null;
    days![DateFormat('yyyy-MM-dd')
        .format(startDatetimeOnlyDay.add(Duration(days: 11)))] = null;
  }

  factory Challange30x30Intervention.fromJson(Map<String, dynamic> json) =>
      _$Challange30x30InterventionFromJson(json);

  Map<String, dynamic> toJson() => _$Challange30x30InterventionToJson(this);

  @override
  List<Object?> get props => [
        userId,
        id,
        startDatetime,
        endDatetime,
        days,
      ];

  Challange30x30Intervention copyWith({
    String? userId,
    String? id,
    DateTime? startDatetime,
    DateTime? endDatetime,
    Map<String, ChallangeOneDayStats?>? days,
  }) {
    return Challange30x30Intervention(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      startDatetime: startDatetime ?? this.startDatetime,
      endDatetime: endDatetime ?? this.endDatetime,
      days: days ?? this.days,
    );
  }
}
