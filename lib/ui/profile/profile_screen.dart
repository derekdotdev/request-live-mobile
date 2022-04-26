import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:request_live/constants/colors.dart';
import 'package:request_live/constants/utils.dart';

import '../../models/user_model.dart';
import '../../models/user_model.dart';
import '../../resources/firestore_database.dart';
import '../../routes.dart';
import '../../app_localizations.dart';
import '../../constants/global_variables.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../drawer/app_drawer.dart';
import './follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  late FirestoreDatabase firestoreDatabase;
  Uri photoUrl = Uri.parse("https://i.stack.imgur.com/l60Hf.png");

  @override
  void initState() {
    super.initState();
    firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
    getData();
  }

  @override
  void dispose() {
    userData.clear();
    super.dispose();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var userSnap = await firestoreDatabase.userData(widget.uid);
      userData = userSnap.data()!;
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context);
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context);
    var userDetails = firestoreDatabase.getUserDetails();

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: width > webScreenSize
                ? null
                : AppBar(
                    backgroundColor: mobileBackgroundColor,
                    centerTitle: false,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          userData['username'].toString().toUpperCase() +
                              '\'s PROFILE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.exit_to_app),
                        onPressed: () {
                          _confirmSignOut(context);
                        },
                      ),
                    ],
                  ),
            drawer: width < webScreenSize ? null : const AppDrawer(),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: userData['photo_url'] != null
                                ? NetworkImage(
                                    photoUrl.toString(),
                                  )
                                : NetworkImage(
                                    userData['photo_url'].toString()),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(0, 'posts'),
                                    buildStatColumn(0, 'followers'),
                                    buildStatColumn(0, 'following'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser?.uid ==
                                            widget.uid
                                        ? Container(
                                            height: 0,
                                            width: 0,
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                text: 'Unfollow',
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black,
                                                borderColor: Colors.grey,
                                                function: () async {
                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                text: 'Follow',
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.white,
                                                borderColor: Colors.blue,
                                                function: () async {
                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                },
                                              ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  _confirmSignOut(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        material: (_, PlatformTarget target) => MaterialAlertDialogData(
            backgroundColor: Theme.of(context).appBarTheme.color),
        title: Text(AppLocalizations.of(context).translate("alertDialogTitle")),
        content:
            Text(AppLocalizations.of(context).translate("alertDialogMessage")),
        actions: <Widget>[
          PlatformDialogAction(
            child: PlatformText(
                AppLocalizations.of(context).translate("alertDialogCancelBtn")),
            onPressed: () => Navigator.pop(context),
          ),
          PlatformDialogAction(
            child: PlatformText(
                AppLocalizations.of(context).translate("alertDialogYesBtn")),
            onPressed: () {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);

              authProvider.signOut();

              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.login, ModalRoute.withName(Routes.login));
            },
          )
        ],
      ),
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
