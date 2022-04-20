import 'package:flutter/material.dart';

class RequestTile extends StatelessWidget {
  RequestTile(this.artist, this.title, this.notes, this.userName,
      this.userEmail, this.isMe, this.entertainerId,
      {required this.key});

  final String artist;
  final String title;
  final String notes;
  final String userName;
  final String userEmail;
  final bool isMe;
  final String entertainerId;
  final Key key;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
        child: Row(
          children: [
            Text(artist),
            Text(title),
            Text(notes),
            Text((userName.trim() == '') ? userEmail : userName),
          ],
        ),
      ),
    );
  }
}
