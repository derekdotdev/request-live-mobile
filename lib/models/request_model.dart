import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String id;
  final String artist;
  final String title;
  final String notes;
  final String requester_id;
  final String entertainer_id;
  final bool played;
  final Timestamp timestamp;

  RequestModel({
    required this.id,
    required this.artist,
    required this.title,
    required this.notes,
    required this.requester_id,
    required this.entertainer_id,
    required this.played,
    required this.timestamp,
  });

  factory RequestModel.fromMap(Map<String, dynamic> data, String documentId) {
    String artist = data['artist'];
    String title = data['title'];
    String notes = data['notes'];
    String requester_id = data['requester_id'];
    String entertainer_id = data['entertainer_id'];
    bool played = data['played'];
    Timestamp timestamp = data['timestamp'];

    return RequestModel(
      id: documentId,
      artist: artist,
      title: title,
      notes: notes,
      requester_id: requester_id,
      entertainer_id: entertainer_id,
      played: played,
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'artist': artist,
      'title': title,
      'notes': notes,
      'requester_id': requester_id,
      'entertainer_id': entertainer_id,
      'played': played,
      'timestamp': timestamp,
    };
  }
}
