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
  final List<String> _userNamesInUse = [];
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchExistingUserNames();
  }

  Future<void> _fetchExistingUserNames() async {
    print('_getUserNamesInUse Called...');

    setState(() {
      _isLoading = true;
    });
    await FirebaseFirestore.instance.collection('users').get().then(
          (querySnapshot) => {
            querySnapshot.docs.forEach((doc) {
              _userNamesInUse.add(doc['username']);
            }),
          },
        );
    setState(() {
      _isLoading = false;
    });
  }

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
      setState(() {
        _isLoading = true;
      });
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

        // Create firebase doc with username.
        // Later used to validate usernames and create routes
        // TODO Replace below with simple username table.
        // TODO This table needs to be made available to !auth in order to validate usernames
        await FirebaseFirestore.instance
            .collection('usernames')
            .doc(username)
            .set(
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
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _userNamesInUse,
        _isLoading,
      ),
    );
  }
}
