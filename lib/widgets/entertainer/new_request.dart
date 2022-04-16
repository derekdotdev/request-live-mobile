import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewRequest extends StatefulWidget {
  final String entertainerId;

  NewRequest(this.entertainerId);

  @override
  State<NewRequest> createState() => _NewRequestState();
}

class _NewRequestState extends State<NewRequest> {
  final user = FirebaseAuth.instance.currentUser;
  final _controller = TextEditingController();
  var _artist = '';
  var _title = '';
  var _notes = '';

  Future<void> _sendRequest() async {
    // Hide soft keyboard
    FocusScope.of(context).unfocus();

    // Persist request in database
    try {
      await FirebaseFirestore.instance
          .collection('entertainers')
          .doc(widget.entertainerId)
          .collection('requests')
          .add(
        {
          'artist': _artist,
          'title': _title,
          'notes': _notes,
          'requested_by': user!.uid,
          'entertainer': widget.entertainerId,
          'timestamp': Timestamp.now(),
        },
      );
    } catch (err) {
      print(err);
    }

    // Clear TextFields
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Artist'),
              onChanged: (value) {
                setState(() {
                  _artist = value;
                });
              },
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Notes'),
              onChanged: (value) {
                setState(() {
                  _notes = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: const Icon(
              Icons.send,
            ),
            onPressed: (_artist.trim().isEmpty || _title.trim().isEmpty)
                ? null
                : _sendRequest,
          ),
        ],
      ),
    );
  }
}
