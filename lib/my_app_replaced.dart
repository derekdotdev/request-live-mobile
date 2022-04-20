// import 'firebase_options.dart';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import './ui/auth/auth_screen.dart';
// import './ui/entertainer/entertainer_screen.dart';
// import './ui/home/welcome_screen.dart';
// import './ui/requests/requests_screen.dart';
// import './ui/splash/splash_screen.dart';
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     final Future<FirebaseApp> _initialization = Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//
//     return FutureBuilder(
//       // Initialize FlutterFire
//       future: _initialization,
//       builder: (context, appSnapshot) {
//         return MaterialApp(
//           title: 'Request Live Music',
//           theme: ThemeData(
//             primarySwatch: Colors.purple,
//             backgroundColor: Colors.white,
//             primaryColor: Colors.purple,
//             buttonTheme: ButtonTheme.of(context).copyWith(
//               buttonColor: Colors.purple,
//               textTheme: ButtonTextTheme.primary,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//           ),
//           home: appSnapshot.connectionState != ConnectionState.done
//               ? SplashScreen()
//               : StreamBuilder(
//                   stream: FirebaseAuth.instance.authStateChanges(),
//                   builder: (ctx, userSnapshot) {
//                     if (userSnapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return SplashScreen();
//                     }
//                     if (userSnapshot.hasData) {
//                       return WelcomeScreen();
//                     }
//                     return AuthScreen();
//                   },
//                 ),
//           routes: {
//             AuthScreen.routeName: (ctx) => AuthScreen(),
//             WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
//             // SearchScreen.routeName: (ctx) => SearchScreen(),
//             EntertainerScreen.routeName: (ctx) => EntertainerScreen(),
//             RequestsScreen.routeName: (ctx) => RequestsScreen(),
//           },
//         );
//       },
//     );
//   }
// }
