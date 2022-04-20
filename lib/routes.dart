import 'package:flutter/material.dart';
import '/ui/auth/auth_screen.dart';
import '/ui/home/welcome_screen.dart';
import '/ui/splash/splash_screen.dart';

class Routes {
  Routes._(); //this is to prevent anyone from instantiate this object

  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String register = '/register';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String create_edit_todo = '/create_edit_todo';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    auth: (BuildContext context) => AuthScreen(),
    home: (BuildContext context) => WelcomeScreen(),
    // settings: (BuildContext context) => SettingsScreen(),
    // create_edit_todo: (BuildContext context) => CreateEditTodoScreen(),
  };
}
