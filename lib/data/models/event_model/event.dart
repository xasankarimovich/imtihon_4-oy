import 'package:cloud_firestore/cloud_firestore.dart';
class EventModel {
  final String uid;
  final String title;
  final String name;
  final DateTime date;
  final String location;
  final String description;
  final String imageUrl;
  EventModel({
    required this.title,
    required this.uid,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
    required this.imageUrl,
  });
  factory EventModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return EventModel(
      title: json['title'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      date: json['date'] != null
          ? (json['date'] as Timestamp)
              .toDate()
          : DateTime.now(),
      location: json['location'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'],
    );
  }
  EventModel copyWith({
    String? uid,
    String? title,
    String? name,
    DateTime? date,
    String? location,
    String? description,
    String? imageUrl,
  }) {
    return EventModel(
      title: title ?? this.title,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      date: date ?? this.date,
      location: location ?? this.location,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
  static EventModel initialValue() => EventModel(
        title: '',
        uid: '',
        name: '',
        date: DateTime.now(),
        location: '',
        description: '',
        imageUrl: '',
      );
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': Timestamp.fromDate(date),
      'location': location,
      'description': description,
      'title': title,
      'uid': uid,
      'image_Url': imageUrl,
    };
  }

  static List<int> _parseLocation(dynamic locationData) {
    if (locationData is List<dynamic>) {
      return locationData.cast<int>();
    }
    if (locationData is String) {
      return locationData
          .split(',')
          .map((e) => int.tryParse(e.trim()) ?? 0)
          .toList();

    }
    return [];
  }
}
