// import 'package:equatable/equatable.dart';
//
// import '../../data/models/event_model/event.dart';
//
// abstract class EventState extends Equatable {
//   const EventState();
//
//   @override
//   List<Object> get props => [];
// }
//
// class EventInitial extends EventState {}
//
// class EventLoading extends EventState {}
//
// class EventLoaded extends EventState {
//   final List<EventModel> events;
//
//   const EventLoaded(this.events);
//
//   @override
//   List<Object> get props => [events];
// }
//
// class EventError extends EventState {
//   final String message;
//
//   const EventError(this.message);
//
//   @override
//   List<Object> get props => [message];
// }

import '../../data/models/forms_status.dart';
import '../../data/models/user/user_model.dart';
class UserState {
  final String errorMessage;
  final UserModel userData;
  final FormsStatus status;

  UserState(
      {required this.errorMessage,
        required this.userData,
        required this.status});

  UserState copyWith({
    String? errorMessage,
    UserModel? userData,
    FormsStatus? status,
  }) =>
      UserState(
        errorMessage: errorMessage ?? this.errorMessage,
        userData: userData ?? this.userData,
        status: status ?? this.status,
      );

  static UserState initialValue() => UserState(
    errorMessage: '',
    userData: UserModel.initialValue(),
    status: FormsStatus.initial,
  );
}
