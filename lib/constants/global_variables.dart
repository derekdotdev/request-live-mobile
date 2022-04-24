import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:instagram_clone_flutter/screens/add_post_screen.dart';
import '../ui/home/welcome_screen.dart';
import '../ui/entertainer/entertainer_screen.dart';
import '../ui/profile/profile_screen.dart';
import '../ui/search/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const WelcomeScreen(),
  const SearchScreen(),
  const EntertainerScreen(),
  const Text('notifications'),
  ProfileScreen(
      // uid: FirebaseAuth.instance.currentUser!.uid,
      ),
];
