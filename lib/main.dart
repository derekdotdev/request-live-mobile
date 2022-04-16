import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
      // Initialize FlutterFire
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print('Something went wrong');
          return Scaffold(
            body: Center(
              child: Text(
                snapshot.error.toString(),
              ),
            ),
          );
        }

        // Once complete, show application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Request Live Music',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              backgroundColor: Colors.white,
              primaryColor: Colors.purple,
              buttonTheme: ButtonTheme.of(context).copyWith(
                buttonColor: Colors.purple,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            home: AuthScreen(),
            routes: {
              AuthScreen.routeName: (ctx) => AuthScreen(),
            },
          );
        }

        // Otherwise, show spinner while waiting
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
