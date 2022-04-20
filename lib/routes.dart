import 'package:flutter/material.dart';
import '/ui/auth/sign_in_screen.dart';
import '/ui/auth/register_screen.dart';
import '/ui/entertainer/entertainer_screen.dart';
import '/ui/home/welcome_screen.dart';
import '/ui/requests/requests_screen.dart';
import '/ui/splash/splash_screen.dart';

class Routes {
  Routes._(); //this is to prevent anyone from instantiating this object

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String entertainer = '/entertainer';
  static const String home = '/home';
  static const String requests = '/requests';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => const SplashScreen(),
    login: (BuildContext context) => SignInScreen(),
    register: (BuildContext context) => RegisterScreen(),
    home: (BuildContext context) => const WelcomeScreen(),
    requests: (BuildContext context) => const RequestsScreen(),
    entertainer: (BuildContext context) => const EntertainerScreen(),
  };
}
