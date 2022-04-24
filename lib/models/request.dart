import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  final String uid;
  final String artist;
  final String title;
  final String notes;
  final String requesterId;
  final String entertainerId;
  final bool played;
  final Timestamp timestamp;

  Request({
    required this.uid,
    required this.artist,
    required this.title,
    required this.notes,
    required this.requesterId,
    required this.entertainerId,
    required this.played,
    required this.timestamp,
  });

  static Request fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Request(
      uid: snapshot["uid"],
      artist: snapshot["artist"],
      title: snapshot["title"],
      notes: snapshot["notes"],
      requesterId: snapshot["requesterId"],
      entertainerId: snapshot["entertainerId"],
      played: snapshot["played"],
      timestamp: snapshot["timestamp"],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'artist': artist,
        'title': title,
        'notes': notes,
        'requester_id': requesterId,
        'entertainer_id': entertainerId,
        'played': played,
        'timestamp': timestamp,
      };

  factory Request.fromMap(Map<String, dynamic> data, String documentId) {
    String artist = data['artist'];
    String title = data['title'];
    String notes = data['notes'];
    String requesterId = data['requester_id'];
    String entertainerId = data['entertainer_id'];
    bool played = data['played'];
    Timestamp timestamp = data['timestamp'];

    return Request(
      uid: documentId,
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
      'uid': uid,
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
