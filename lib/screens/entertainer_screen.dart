import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class EntertainerScreen extends StatefulWidget {
  @override
  State<EntertainerScreen> createState() => _EntertainerScreenState();
}

class _EntertainerScreenState extends State<EntertainerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entertainer\'s Page'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Welcome to Request Live!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            TextField()
          ],
        ),
      ),
    );
  }
}
