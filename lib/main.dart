import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/auth_screen.dart';
import './screens/welcome_screen.dart';
import './screens/splash_screen.dart';

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
      builder: (context, appSnapshot) {
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
          home: appSnapshot.connectionState != ConnectionState.done
              ? SplashScreen()
              : StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (ctx, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SplashScreen();
                    }
                    if (userSnapshot.hasData) {
                      return WelcomeScreen();
                    }
                    return AuthScreen();
                  },
                ),
          routes: {
            AuthScreen.routeName: (ctx) => AuthScreen(),
          },
        );
      },
    );
  }
}
