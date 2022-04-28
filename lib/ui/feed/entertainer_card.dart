import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
// import 'package:instagram_clone_flutter/providers/user_provider.dart';
// import 'package:instagram_clone_flutter/resources/firestore_methods.dart';
// import 'package:instagram_clone_flutter/screens/comments_screen.dart';
import '../../constants/colors.dart';
import '../../constants/global_variables.dart';
import '../../constants/utils.dart';
// import 'package:instagram_clone_flutter/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../routes.dart';
import '../entertainer/entertainer_screen.dart';
import 'like_animation.dart';

class EntertainerCard extends StatefulWidget {
  final snap;

  const EntertainerCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<EntertainerCard> createState() => _EntertainerCardState();
}

class _EntertainerCardState extends State<EntertainerCard> {
  late String userImageUrl = widget.snap['photo_url'].toString();
  // late String stockPhotoUrl = 'request-live-4864a.appspot.com/user.png';
  late String stockPhotoUrl = 'https://i.stack.imgur.com/l60Hf.png';
  final loggedInUser = FirebaseAuth.instance.currentUser;
  late String userId;
  int commentLen = 0;
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    userId = loggedInUser!.uid;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Do not display current user's EntertainerCard
    return widget.snap['uid'] == userId
        ? Container()
        : widget.snap['is_entertainer'] == false
            ? Container()
            : GestureDetector(
                key: Key(widget.snap['uid']),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundImage: NetworkImage(
                            stockPhotoUrl,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          children: [
                            Text(
                              widget.snap['username'].toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'Location',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Navigate to entertainer's page!
                onTap: () {
                  // TODO Navigate to entertainer's page!
                  Navigator.pushNamed(
                    context,
                    Routes.entertainer,
                    arguments: EntertainerScreenArgs(
                      // TODO figure this out!
                      widget.snap['uid'].toString(),
                      widget.snap['username'].toString(),
                    ),
                  );
                },
              );
  }
}
