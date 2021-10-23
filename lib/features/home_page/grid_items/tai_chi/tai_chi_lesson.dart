import 'dart:convert';

import 'package:equatable/equatable.dart';

class TaiChiLesson extends Equatable {
  const TaiChiLesson({
    required this.id,
    required this.ytVideoId,
    required this.title,
    required this.description,
  });
  final String id;
  final String ytVideoId;
  final String title;
  final String description;

  factory TaiChiLesson.fromTaiChiLessonNoId({
    required TaiChiLessonNoId taiChiLessonNoId,
    required String docId,
  }) {
    return TaiChiLesson(
      id: docId,
      description: taiChiLessonNoId.description,
      title: taiChiLessonNoId.title,
      ytVideoId: taiChiLessonNoId.ytVideoId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        ytVideoId,
        title,
        description,
      ];

  TaiChiLesson copyWith({
    String? id,
    String? ytVideoId,
    String? title,
    String? description,
  }) {
    return TaiChiLesson(
      id: id ?? this.id,
      ytVideoId: ytVideoId ?? this.ytVideoId,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ytVideoId': ytVideoId,
      'title': title,
      'description': description,
    };
  }

  factory TaiChiLesson.fromMap(Map<String, dynamic> map) {
    return TaiChiLesson(
      id: map['id'],
      ytVideoId: map['ytVideoId'],
      title: map['title'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TaiChiLesson.fromJson(String source) =>
      TaiChiLesson.fromMap(json.decode(source));
}

class TaiChiLessonNoId {
  const TaiChiLessonNoId({
    required this.ytVideoId,
    required this.title,
    required this.description,
  });
  final String ytVideoId;
  final String title;
  final String description;
}

final List<TaiChiLessonNoId> taiChiLessons = [
  TaiChiLessonNoId(
    ytVideoId: 'cEOS2zoyQw4',
    title: 'Tai Chi 5 Minutes a Day Module 01 - easy for beginners',
    description: """
Simple Easy beginners Tai Chi. 

Get these YouTube videos in your inbox. https://www.taiflow.com/taiflow-signup
and learn more about Leia's history and the path that lead her to Tai Chi.

Follow my Instagram : @leiacohen
https://www.instagram.com/leiacohen/

Like my Facebook page : https://www.facebook.com/tailfow/

Join my Facebook group:
https://www.facebook.com/groups/11900...

*Note: I will only accept you into the group if you answer my questions and it is ok to be in the group if you haven't started your Tai Chi journey yet :)

Leia Cohen Health Coach Like my page: https://www.facebook.com/greenearthmind/

Follow me on Twitter: @cohenleia

For the next videos in the series: 
https://www.taiflow.com/Silver-Freest...
    """,
  ),
  TaiChiLessonNoId(
    ytVideoId: 'fNm2FWi1vkI',
    title: 'UPDATED: Tai Chi 5 min a day Module 02 - no music',
    description:
        """Tai Chi for beginners, without music so you can play your own. Remember to practice even for only 5 minutes but everyday. That will keep you in the universal flow and your Tai Chi practice will flourish.

Get these YouTube videos in your inbox. https://www.taiflow.com/taiflow-signup
and learn more about Leia's history and the path that lead her to Tai Chi.

Follow my Instagram : @leiacohen
https://www.instagram.com/leiacohen/

Like my Facebook page : https://www.facebook.com/tailfow/

Join my Facebook group:
https://www.facebook.com/groups/11900...

*Note: I will only accept you into the group if you answer my questions and it is ok to be in the group if you haven't started your Tai Chi journey yet :)

Leia Cohen Health Coach Like my page: https://www.facebook.com/greenearthmind/

Follow me on Twitter: @cohenleia

For the next videos in the series: 
https://www.taiflow.com/Silver-Freest...
""",
  ),
  TaiChiLessonNoId(
    ytVideoId: 'X1dyl_yHA84',
    title: 'UPDATED: Module 03 beginners Tai Chi (one camera new music)',
    description:
        """One camera without cuts in the movements for those who have been saying it was hard to follow the movement. It is the same as before but just the front view, I hope it is easier to follow. I also changed the music so I would like to know which you prefer. Remember even only 5 minutes a day everyday can change your life. 

Get these YouTube videos in your inbox. https://www.taiflow.com/taiflow-signup
and learn more about Leia's history and the path that lead her to Tai Chi.

Follow my Instagram : @leiacohen
https://www.instagram.com/leiacohen/

Like my Facebook page : https://www.facebook.com/tailfow/

Join my Facebook group:
https://www.facebook.com/groups/11900...

*Note: I will only accept you into the group if you answer my questions and it is ok to be in the group if you haven't started your Tai Chi journey yet :)

Leia Cohen Health Coach Like my page: https://www.facebook.com/greenearthmind/

Follow me on Twitter: @cohenleia

For the next videos in the series: 
https://www.taiflow.com/Silver-Freest...""",
  ),
  TaiChiLessonNoId(
    ytVideoId: 'RoIqYtiTLFI',
    title: 'UPDATED: Module 04 beginners Tai Chi (one camera - new music)',
    description:
        """One camera so that there aren't cuts in the movements for those who have been saying it was hard to follow the movement. It is the same as before but just the front view and I hope it is easier to follow. I also changed the music so I would like to know which you prefer. Remember even only 5 minutes a day everyday can change your life.

Get these YouTube videos in your inbox. https://www.taiflow.com/taiflow-signup
and learn more about Leia's history and the path that lead her to Tai Chi.

Follow my Instagram : @leiacohen
https://www.instagram.com/leiacohen/

Like my Facebook page : https://www.facebook.com/tailfow/

Join my Facebook group:
https://www.facebook.com/groups/11900...

*Note: I will only accept you into the group if you answer my questions and it is ok to be in the group if you haven't started your Tai Chi journey yet :)

Leia Cohen Health Coach Like my page: https://www.facebook.com/greenearthmind/

Follow me on Twitter: @cohenleia

For the next videos in the series: 
https://www.taiflow.com/Silver-Freest...""",
  ),
  TaiChiLessonNoId(
    ytVideoId: 'HJi-T2_0OeM',
    title: 'Tai Chi five minutes a day module 05 - no music',
    description:
        """For those of you who prefer to use your own music have fun and don't forget 5 minutes a everyday can change your life!

Get these YouTube videos in your inbox. https://www.taiflow.com/taiflow-signup
and learn more about Leia's history and the path that lead her to Tai Chi.

Follow my Instagram : @leiacohen
https://www.instagram.com/leiacohen/

Like my Facebook page : https://www.facebook.com/tailfow/

Join my Facebook group:
https://www.facebook.com/groups/11900...

*Note: I will only accept you into the group if you answer my questions and it is ok to be in the group if you haven't started your Tai Chi journey yet :)

Leia Cohen Health Coach Like my page: https://www.facebook.com/greenearthmind/

Follow me on Twitter: @cohenleia

For the next videos in the series: 
https://www.taiflow.com/Silver-Freest...""",
  ),
];
