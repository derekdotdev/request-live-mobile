import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class RequestsScreenArgs {
  final String entertainerUid;
  final String entertainerUserName;
  RequestsScreenArgs(this.entertainerUid, this.entertainerUserName);
}

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  static const routeName = '/requests/';

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    FirebaseMessaging.onMessage.listen((message) {
      print(message);
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message);
      return;
    });
    fbm.subscribeToTopic('chat');
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as RequestsScreenArgs;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Welcome to your requests page!' + args.entertainerUserName),
          ],
        ),
      ),
    );
  }
}
