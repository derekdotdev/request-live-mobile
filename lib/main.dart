import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import './flavor.dart';
import './my_app.dart';
import './providers/auth_provider.dart';
import './providers/language_provider.dart';
import './providers/request_provider.dart';
import './providers/theme_provider.dart';
import './resources/firestore_database.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Recommended way to initialize from flutter fire docs
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    runApp(
      MultiProvider(
        providers: [
          Provider<Flavor>.value(value: Flavor.dev),
          ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider(),
          ),
          ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider(),
          ),
          ChangeNotifierProvider<LanguageProvider>(
            create: (context) => LanguageProvider(),
          ),
          ChangeNotifierProvider<RequestProvider>(
            create: (context) => RequestProvider(),
          ),
          // ChangeNotifierProvider<EntertainerProvider>(
          //   create: (context) => EntertainerProvider(),
          // )
        ],
        child: MyApp(
          databaseBuilder: (_, uid) => FirestoreDatabase(uid: uid),
          key: const Key('MyApp'),
        ),
      ),
    );
  });
}
