import 'package:equatable/equatable.dart';

import '../../data/models/event_model/event.dart';

abstract class EventStateEvent{}

class FetchEvent extends EventStateEvent{}
class InsertEvent extends EventStateEvent{
  final List<EventModel> events;
  final EventModel insertEvent;
  InsertEvent({required this.events, required this.insertEvent});
}
class EventSearch extends EventStateEvent {
  final String name;
  EventSearch(this.name);
}
class DeleteEvent extends EventStateEvent {
  final String eventId;

  DeleteEvent(this.eventId);
}




