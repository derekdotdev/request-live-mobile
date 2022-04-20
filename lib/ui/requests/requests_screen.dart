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
    // FirebaseMessaging messaging = FirebaseMessaging.instance;
    // NotificationSettings settings = await messaging.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );
    // print('User granted permission: ${settings.authorizationStatus}');

    // Enable FirebaseMessaging
    final fbm = FirebaseMessaging.instance;

    // Ask for push notification permission (iOS)
    fbm.requestPermission();

    // Handle notifications which call back from background (resume)
    FirebaseMessaging.onMessage.listen((message) {
      print(message);
      return;
    });

    // Handle notifications which re-open (launch) the app
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message);
      return;
    });

    // fbm.subscribeToTopic('requests/entertainer.uid/all');
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
