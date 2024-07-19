import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../data/models/event_model/event.dart';
import '../../data/models/forms_status.dart';
import 'event_state_event.dart';
import 'event_state_state.dart';

class EventBloc extends Bloc<EventStateEvent, EventState> {
  EventBloc() : super(EventState.initialValue()) {
    on<FetchEvent>(_fetchEvents);
    on<InsertEvent>(_insertEvent);
    on<EventSearch>(_onSearch);
    on<DeleteEvent>(_deleteEvent); // DeleteEvent hodisasini ishlash uchun qo'shish
  }

  // _fetchEvents funksiyasi 'FetchEvent' hodisasi yuzaga kelganda chaqiriladi.+++++++++++++++++++
  Future<void> _fetchEvents(FetchEvent event, Emitter<EventState> emit) async {
    emit(state.copyWith(status: FormsStatus.loading));
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('events').get();
      List<EventModel> eventData = querySnapshot.docs.map(
            (doc) {
          return EventModel.fromJson(
            doc.data() as Map<String, dynamic>,
          );
        },
      ).toList(); // Malumotlarni  EventModel'ga aylantiradi yani biz tusunadigan tilga ayrlantiradi++++++++++++++++.
      emit(state.copyWith(
        status: FormsStatus.success,
        eventData: eventData, // Olingan eventlarni state'ga saqlaydi.+++++++++++++++++++++++++++++++
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormsStatus.error,
        errorMessage: e.toString(),
      ));

      debugPrint('Failed to fetch events: _______________________________________$e');
    }
  }

  // _insertEvent funksiyasi 'InsertEvent' hodisasi yuzaga kelganda chaqiriladi.+++++++++++++++++
  Future<void> _insertEvent(InsertEvent event, Emitter<EventState> emit) async {
    try {
      emit(state.copyWith(status: FormsStatus.loading));
      await FirebaseFirestore.instance
          .collection('events')
          .add(event.insertEvent.toJson()); // Yangi event'ni Firestore'ga qo'shamiza______________.
      emit(
        state.copyWith(
          status: FormsStatus.success,
          eventData: event.events,
        ),
      );
    } catch (error) {
      emit(state.copyWith(
        status: FormsStatus.error,
        errorMessage: error.toString(),
      ));
      debugPrint('Failed to insert event:+++++++++++++++++++++++++++++++++ $error');
    }
  }

  // _onSearch funksiyasi 'EventSearch' hodisasi yuzaga kelganda chaqiriladi.
  Future<void> _onSearch(EventSearch event, Emitter<EventState> emit) async {
    emit(state.copyWith(status: FormsStatus.loading));
    try {
      List<EventModel> filteredEvents = state.eventData.where((e) {
        return e.name.toLowerCase().contains(event.name.toLowerCase());
      }).toList();
      emit(state.copyWith(
        status: FormsStatus.success,
        eventData: filteredEvents, // Filtrlangan eventlarni state'ga saqlaydi.+++++++++++++++++++++++++++=
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormsStatus.error,
        errorMessage: e.toString(),
      ));
      debugPrint('Failed to search events:+++++++++++++++++++++++++++++++ $e');
    }
  }


  Future<void> _deleteEvent(DeleteEvent event, Emitter<EventState> emit) async {
    try {
      emit(state.copyWith(status: FormsStatus.loading));
      await FirebaseFirestore.instance.collection('events').doc(event.eventId).delete(); // Eventni Firestore'dan o'chirish
      // O'chirilganidan keyin yangilangan eventlarni qayta yuklash
      add(FetchEvent());
    } catch (error) {
      emit(state.copyWith(
        status: FormsStatus.error,
        errorMessage: error.toString(),
      ));
      debugPrint('Failed to delete event: $error');
    }
  }


}
