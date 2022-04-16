import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/search_screen.dart';
import '../screens/welcome_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Options'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Main'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(WelcomeScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Find Nearby Entertainers'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(SearchScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
