import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:request_live/constants/global_variables.dart';

import '../../constants/colors.dart';
import '../../models/request.dart';
import '../../providers/request_provider.dart';
import '../../resources/conversions.dart';
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
    final height = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context);
    final requestProvider =
        Provider.of<RequestProvider>(context, listen: false);
    final args =
        ModalRoute.of(context)!.settings.arguments as RequestDetailScreenArgs;
    var _isPlayed = args.request.played;
    late bool _played;
    var _isLoading = false;

    void updatePlayedStatus() {
      setState(() {
        _isLoading = true;
      });
      requestProvider.updateRequestPlayed(args.request);
      setState(() {
        _isLoading = false;
      });
    }

    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        : Scaffold(
            backgroundColor: width > webScreenSize
                ? webBackgroundColor
                : mobileBackgroundColor,
            appBar: width > webScreenSize
                ? null
                : AppBar(
                    title: const Text(
                      'Request Details',
                    ),
                  ),
            // drawer: AppDrawer(),
            body: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          margin: EdgeInsets.only(top: 16),
                          elevation: 4,
                          color: webBackgroundColor,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CircleAvatar(
                                  radius: 48,
                                  backgroundImage: NetworkImage(
                                    args.request.requesterPhotoUrl,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Text(
                                  args.request.requesterUsername,
                                  style: kRequestDetailStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Card(
                          elevation: 4,
                          color: webBackgroundColor,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: RequestRowOld(
                                  section: 'Artist: ',
                                  details: args.request.artist,
                                  maxLines: 1,
                                ),
                              ),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: RequestRowOld(
                                  section: 'Title: ',
                                  details: args.request.title,
                                  maxLines: 1,
                                ),
                              ),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: RequestColumn(
                                  section: 'Notes: ',
                                  details: args.request.notes,
                                  maxLines: 3,
                                ),
                              ),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: RequestRowOld(
                                  section: 'Time: ',
                                  details: Conversions.convertTimeStamp(
                                      args.request.timestamp),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Card(
                          elevation: 4,
                          color: webBackgroundColor,
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 16,
                                  left: 16,
                                  right: 16,
                                ),
                                child: Text(
                                  'Did you play it??',
                                  style: kRequestDetailStyle,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Switch.adaptive(
                                  value: _isPlayed,
                                  activeColor: Colors.orangeAccent,
                                  onChanged: (value) {
                                    updatePlayedStatus();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
}

class RequestColumn extends StatelessWidget {
  final String section;
  final String details;
  final int maxLines;

  const RequestColumn({
    Key? key,
    required this.section,
    required this.details,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            section,
            style: kRequestDetailStyle,
          ),
        ),
        Flexible(
          // flex: 2,
          child: Text(
            details == '' ? 'none' : details,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class RequestRowOld extends StatelessWidget {
  final String section;
  final String details;
  final int maxLines;

  const RequestRowOld({
    Key? key,
    required this.section,
    required this.details,
    required this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Text(
            section,
            style: kRequestDetailStyle,
          ),
        ),
        Flexible(
          flex: 2,
          child: Text(
            details == '' ? 'none' : details,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
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
