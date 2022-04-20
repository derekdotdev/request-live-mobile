import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String id;
  final String artist;
  final String title;
  final String notes;
  final String requesterId;
  final String entertainerId;
  final bool played;
  final Timestamp timestamp;

  RequestModel({
    required this.id,
    required this.artist,
    required this.title,
    required this.notes,
    required this.requesterId,
    required this.entertainerId,
    required this.played,
    required this.timestamp,
  });

  factory RequestModel.fromMap(Map<String, dynamic> data, String documentId) {
    String artist = data['artist'];
    String title = data['title'];
    String notes = data['notes'];
    String requesterId = data['requester_id'];
    String entertainerId = data['entertainer_id'];
    bool played = data['played'];
    Timestamp timestamp = data['timestamp'];

    return RequestModel(
      id: documentId,
      artist: artist,
      title: title,
      notes: notes,
      requesterId: requesterId,
      entertainerId: entertainerId,
      played: played,
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'artist': artist,
      'title': title,
      'notes': notes,
      'requester_id': requesterId,
      'entertainer_id': entertainerId,
      'played': played,
      'timestamp': timestamp,
    };
  }
}
