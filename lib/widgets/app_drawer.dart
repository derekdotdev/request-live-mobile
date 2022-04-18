import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/requests_screen.dart';
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
            title: const Text('Options'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Main'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(WelcomeScreen.routeName);
            },
          ),
          const Divider(),
          // TODO use determine if a user is an entertainer and conditionally show 'my requests'
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('My Requests'),
            onTap: () {
              Navigator.pushNamed(
                context,
                RequestsScreen.routeName,
                arguments: RequestsScreenArgs(
                  // TODO figure this out!
                  'entertainerUID', 'entertainerDisplayName',
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Find Nearby Entertainers'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(SearchScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
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
