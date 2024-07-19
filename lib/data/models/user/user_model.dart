
import 'package:imtihon_4oyuchun/data/models/user/user_model_constants.dart';

import '../event_model/event.dart';

class UserModel {
  final String uid;
  final String fcmToken;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final List<EventModel> myEvent;
  final List<EventModel> isLiked;
  final List<EventModel> attendanceEvent;
  final List<EventModel> lateEvent;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.myEvent,
    required this.isLiked,
    required this.attendanceEvent,
    required this.lateEvent,
    required this.fcmToken,
    required this.uid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json[UserModelConstants.firstName] as String? ?? '',
        lastName: json[UserModelConstants.lastName] as String? ?? '',
        email: json[UserModelConstants.email] as String? ?? '',
        password: json[UserModelConstants.password] as String? ?? '',
        myEvent: (json[UserModelConstants.myEvent] as List?)
                ?.map((e) => EventModel.fromJson(e))
                .toList() ??
            [],
        isLiked: (json[UserModelConstants.isLiked] as List?)
                ?.map((e) => EventModel.fromJson(e))
                .toList() ??
            [],
        attendanceEvent: (json[UserModelConstants.attendanceEvent] as List?)
                ?.map((e) => EventModel.fromJson(e))
                .toList() ??
            [],
        lateEvent: (json[UserModelConstants.lateEvent] as List?)
                ?.map((e) => EventModel.fromJson(e))
                .toList() ??
            [],
        uid: json[UserModelConstants.uid] as String? ?? '',
        fcmToken: json[UserModelConstants.fcmToken] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        UserModelConstants.firstName: firstName,
        UserModelConstants.lastName: lastName,
        UserModelConstants.email: email,
        UserModelConstants.password: password,
        UserModelConstants.myEvent: myEvent.map((e) => e.toJson()),
        UserModelConstants.isLiked: isLiked.map((e) => e.toJson()),
        UserModelConstants.attendanceEvent:
            attendanceEvent.map((e) => e.toJson()),
        UserModelConstants.lateEvent: lateEvent.map((e) => e.toJson()),
        UserModelConstants.uid: uid,
        UserModelConstants.fcmToken: fcmToken,
      };

  Map<String, dynamic> toUpdateJson() => {
        UserModelConstants.firstName: firstName,
        UserModelConstants.lastName: lastName,
        UserModelConstants.email: email,
        UserModelConstants.password: password,
        UserModelConstants.myEvent: myEvent.map((e) => e.toJson()),
        UserModelConstants.isLiked: isLiked.map((e) => e.toJson()),
        UserModelConstants.attendanceEvent:
            attendanceEvent.map((e) => e.toJson()),
        UserModelConstants.lateEvent: lateEvent.map((e) => e.toJson()),
        UserModelConstants.uid: uid,
        UserModelConstants.fcmToken: fcmToken,
      };

  UserModel copyWith({
    String? uid,
    String? fcmToken,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    List<EventModel>? myEvent,
    List<EventModel>? isLiked,
    List<EventModel>? attendanceEvent,
    List<EventModel>? lateEvent,
  }) =>
      UserModel(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        password: password ?? this.password,
        myEvent: myEvent ?? this.myEvent,
        isLiked: isLiked ?? this.isLiked,
        attendanceEvent: attendanceEvent ?? this.attendanceEvent,
        lateEvent: lateEvent ?? this.lateEvent,
        fcmToken: fcmToken ?? this.fcmToken,
        uid: uid ?? this.uid,
      );

  static UserModel initialValue() => UserModel(
        firstName: '',
        lastName: '',
        email: '',
        password: '',
        myEvent: [],
        isLiked: [],
        attendanceEvent: [],
        lateEvent: [],
        fcmToken: '',
        uid: '',
      );
}
