

import '../../data/models/event_model/event.dart';
import '../../data/models/forms_status.dart';

class EventState {
  final String errorMessage;
  final List<EventModel> eventData;
  final FormsStatus status;

  EventState(
      {required this.errorMessage,
      required this.eventData,
      required this.status});

  EventState copyWith({
    String? errorMessage,
    List<EventModel>? eventData,
    FormsStatus? status,
  }) =>
      EventState(
        errorMessage: errorMessage ?? this.errorMessage,
        eventData: eventData ?? this.eventData,
        status: status ?? this.status,
      );

  static EventState initialValue() => EventState(
        errorMessage: '',
        eventData: [],
        status: FormsStatus.initial,
      );
}
