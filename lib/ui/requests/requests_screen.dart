import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:request_live/constants/colors.dart';
import 'package:request_live/ui/requests/request_card.dart';

import '../../constants/global_variables.dart';
import '../../providers/request_provider.dart';
import '../../resources/firestore_database.dart';

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
  String userUid = '';

  @override
  void initState() {
    super.initState();
    userUid = FirebaseAuth.instance.currentUser!.uid;

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
    final width = MediaQuery.of(context).size.width;
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);
    final requestProvider =
        Provider.of<RequestProvider>(context, listen: false);

    Future<bool?> _showConfirmationDialog(BuildContext context, String action) {
      return showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure you want to $action this item?'),
            actions: [
              TextButton.icon(
                label: const Text('Yes'),
                icon: const Icon(Icons.check),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              TextButton.icon(
                label: const Text('No'),
                icon: const Icon(Icons.cancel),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: const Text(
                'Your Requests!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestoreDatabase.requestSnapshotStream(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          return SizedBox(
            width: double.infinity,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              reverse: true,
              shrinkWrap: true,
              itemBuilder: (ctx, index) => Container(
                margin: EdgeInsets.symmetric(
                  horizontal: width > webScreenSize ? width * 0.3 : 0,
                  vertical: width > webScreenSize ? 15 : 0,
                ),
                child: Dismissible(
                  key: ValueKey<int>(index),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onDismissed: (DismissDirection direction) async {
                    requestProvider.deleteRequestById(
                        snapshot.data!.docs[index]
                            .data()['entertainer_id']
                            .toString(),
                        snapshot.data!.docs[index].id);
                    await snapshot.data!.docs[index].reference.delete();
                  },
                  confirmDismiss: (DismissDirection direction) =>
                      _showConfirmationDialog(context, 'delete'),
                  child: RequestCard(
                    requestId: snapshot.data!.docs[index].id,
                    snap: snapshot.data!.docs[index].data(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
