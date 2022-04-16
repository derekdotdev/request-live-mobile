import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  // Submit function to pass in to auth_form
  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    bool isDj,
    BuildContext ctx,
  ) async {
    UserCredential userCredential;

    try {
      if (isLogin) {
        // Log in existing user
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        // Create new user
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(
          {
            'username': username,
            'email': email,
            'isDj': isDj,
          },
        );

        // If a DJ, create firebase doc with username for
        // later use (validate usernames and create routes)
        await FirebaseFirestore.instance.collection('djs').doc(username).set(
          {
            'uid': userCredential.user!.uid,
            'username': username,
            'email': email,
          },
        );
      }
    } on FirebaseAuthException catch (err) {
      String message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message!;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
      ),
    );
  }
}
