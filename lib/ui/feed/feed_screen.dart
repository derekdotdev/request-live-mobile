import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/global_variables.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../resources/firestore_database.dart';
import './entertainer_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);

    final _auth = Provider.of<AuthProvider>(context, listen: false);
    final userDetails = firestoreDatabase.getUserDetails();

    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: const Text(
                'Select an entertainer to make a request!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
              ),
              // actions: [
              //   IconButton(
              //     icon: const Icon(
              //       Icons.messenger_outline,
              //       color: primaryColor,
              //     ),
              //     onPressed: () {},
              //   ),
              // ],
            ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        // stream: FirebaseFirestore.instance.collection('users').snapshots(),
        stream: firestoreDatabase.entertainerSnapshotStream(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > webScreenSize ? width * 0.3 : 0,
                vertical: width > webScreenSize ? 15 : 0,
              ),
              child: EntertainerCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        },
      ),
    );
  }
}
