import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  final String uid;
  final String artist;
  final String title;
  final String notes;
  final String requesterId;
  final String requesterUsername;
  final String requesterPhotoUrl;
  final String entertainerId;
  bool played;
  final Timestamp timestamp;

  Request({
    required this.uid,
    required this.artist,
    required this.title,
    required this.notes,
    required this.requesterId,
    required this.requesterUsername,
    required this.requesterPhotoUrl,
    required this.entertainerId,
    required this.played,
    required this.timestamp,
  });

  void togglePlayed() {
    played = !played;
  }

  static Request fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Request(
      uid: snapshot["uid"],
      artist: snapshot["artist"],
      title: snapshot["title"],
      notes: snapshot["notes"],
      requesterId: snapshot["requester_id"],
      requesterUsername: snapshot['requester_username'],
      requesterPhotoUrl: snapshot['requester_photo_url'],
      entertainerId: snapshot["entertainer_id"],
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
        'requester_username': requesterUsername,
        'requester_photo_url': requesterPhotoUrl,
        'entertainer_id': entertainerId,
        'played': played,
        'timestamp': timestamp,
      };

  factory Request.fromMap(Map<String, dynamic> data, String documentId) {
    String artist = data['artist'];
    String title = data['title'];
    String notes = data['notes'];
    String requesterId = data['requester_id'];
    String requesterUsername = data['requester_username'];
    String requesterPhotoUrl = data['requester_photo_url'];
    String entertainerId = data['entertainer_id'];
    bool played = data['played'];
    Timestamp timestamp = data['timestamp'];

    return Request(
      uid: documentId,
      artist: artist,
      title: title,
      notes: notes,
      requesterId: requesterId,
      requesterUsername: requesterUsername,
      requesterPhotoUrl: requesterPhotoUrl,
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
      'requester_username': requesterUsername,
      'requester_photo_url': requesterPhotoUrl,
      'entertainer_id': entertainerId,
      'played': played,
      'timestamp': timestamp,
    };
  }
}
