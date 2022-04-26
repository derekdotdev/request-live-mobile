import 'package:flutter/material.dart';

class EntertainerBio extends StatelessWidget {
  const EntertainerBio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'BIO GOES HERE',
      style: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
