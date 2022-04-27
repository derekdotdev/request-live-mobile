import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:request_live/constants/global_variables.dart';

import '../../constants/colors.dart';
import '../../models/request.dart';
import '../drawer/app_drawer.dart';
import '../../providers/auth_provider.dart';

class RequestDetailScreenArgs {
  final Request request;
  RequestDetailScreenArgs(this.request);
}

class RequestDetailScreen extends StatefulWidget {
  const RequestDetailScreen({Key? key}) : super(key: key);

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  final _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context);

    final args =
        ModalRoute.of(context)!.settings.arguments as RequestDetailScreenArgs;

    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              title: const Text(
                'Request Details',
              ),
            ),
      // drawer: AppDrawer(),
      body: SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // EntertainerBio(),
              // NewRequestForm(_isLoading, _sendRequest),
            ],
          ),
        ),
      ),
    );
  }
}

//
// Future<void> _updateRequest(
//     String artist,
//     String title,
//     String notes,
//     BuildContext ctx,
//     ) async {
//   final authUser = authProvider.user.map((event) => event.uid);
//   final user = FirebaseAuth.instance.currentUser;
//   // Hide soft keyboard
//   FocusScope.of(context).unfocus();
//
//   // Persist request to database
//   try {
//     if (user == null) {
//       print('authProvider.user == null!');
//     } else {
//       await FirebaseFirestore.instance
//           .collection('entertainers')
//           .doc(args.entertainerUid)
//           .collection('requests')
//           .add(
//         {
//           'artist': artist,
//           'title': title,
//           'notes': notes,
//           'requested_by': user.uid,
//           'entertainer_id': args.entertainerUid,
//           'timestamp': Timestamp.now(),
//         },
//       );
//
//       ScaffoldMessenger.of(ctx).showSnackBar(
//         const SnackBar(
//           content: Text('Your request has been sent!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     }
//   } catch (err) {
//     ScaffoldMessenger.of(ctx).showSnackBar(
//       SnackBar(
//         content: Text('Something went wrong: ' + err.toString()),
//         backgroundColor: Theme.of(ctx).errorColor,
//       ),
//     );
//     print(err);
//     return;
//   }
// }
