import 'package:flutter/material.dart';

class RequestTile extends StatelessWidget {
  RequestTile(this.artist, this.title, this.notes, this.userName, this.isMe,
      this.entertainerId,
      {required this.key});

  final String artist;
  final String title;
  final String notes;
  final String userName;
  final bool isMe;
  final String entertainerId;
  final Key key;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Text(artist),
          Text(title),
          Text(notes),
          Text(userName),
        ],
      ),
    );
  }
}
