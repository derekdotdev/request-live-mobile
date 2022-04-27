import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../resources/firestore_database.dart';

import '../models/request.dart';

class RequestProvider extends ChangeNotifier {
  static bool requestsFetched = false;
  List<Request> requestsListMain = [];

  UnmodifiableListView<Request>? get requests {
    return UnmodifiableListView(requestsListMain);
  }

  int get requestCount {
    return requestsListMain.length;
  }

  void updateRequestPlayed(Request request) {
    // Toggle played on local instance of request
    request.togglePlayed();

    // Create new request
    Request newRequest = Request(
      uid: request.uid,
      artist: request.artist,
      title: request.title,
      notes: request.notes,
      requesterId: request.requesterId,
      requesterUsername: request.requesterUsername,
      requesterPhotoUrl: request.requesterPhotoUrl,
      entertainerId: request.entertainerId,
      played: request.played,
      timestamp: request.timestamp,
    );

    FirestoreDatabase(uid: request.entertainerId).setRequest(request);
    notifyListeners();
  }
}
