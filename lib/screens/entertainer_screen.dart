import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class EntertainerScreenArgs {
  final String uid;
  final String userName;
  EntertainerScreenArgs(this.uid, this.userName);
}

class EntertainerScreen extends StatefulWidget {
  static const routeName = '/entertainer/';

  @override
  State<EntertainerScreen> createState() => _EntertainerScreenState();
}

class _EntertainerScreenState extends State<EntertainerScreen> {
  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as EntertainerScreenArgs;
    return Scaffold(
      appBar: AppBar(
        title: Text('Entertainer\'s Page'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Welcome to Request Live!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            TextField()
          ],
        ),
      ),
    );
  }
}
