import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'new_request_form.dart';
import '../drawer/app_drawer.dart';
import '../../providers/auth_provider.dart';

class EntertainerScreenArgs {
  final String entertainerUid;
  final String entertainerUserName;
  EntertainerScreenArgs(this.entertainerUid, this.entertainerUserName);
}

class EntertainerScreen extends StatefulWidget {
  static const routeName = '/entertainer/';

  const EntertainerScreen({Key? key}) : super(key: key);

  @override
  State<EntertainerScreen> createState() => _EntertainerScreenState();
}

class _EntertainerScreenState extends State<EntertainerScreen> {
  final _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    final args =
        ModalRoute.of(context)!.settings.arguments as EntertainerScreenArgs;

    Future<void> _sendRequest(
      String artist,
      String title,
      String notes,
      BuildContext ctx,
    ) async {
      final authUser = authProvider.user.map((event) => event.uid);
      final user = FirebaseAuth.instance.currentUser;
      // Hide soft keyboard
      FocusScope.of(context).unfocus();

      // Persist request to database
      try {
        if (user == null) {
          print('authProvider.user == null!');
        } else {
          await FirebaseFirestore.instance
              .collection('entertainers')
              .doc(args.entertainerUid)
              .collection('requests')
              .add(
            {
              'artist': artist,
              'title': title,
              'notes': notes,
              'requested_by': user.uid,
              'entertainer_id': args.entertainerUid,
              'timestamp': Timestamp.now(),
            },
          );

          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(
              content: Text('Your request has been sent!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (err) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('Something went wrong: ' + err.toString()),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
        print(err);
        return;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${args.entertainerUserName}\'s Page'),
      ),
      // drawer: AppDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'BIO GOES HERE',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          NewRequestForm(_isLoading, _sendRequest),
        ],
      ),
    );
  }
}
