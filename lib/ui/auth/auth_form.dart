import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.userNamesInUse, this.isLoading);

  // Submit auth form function passed form auth_screen
  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    bool isDj,
    BuildContext ctx,
  ) submitFn;

  final List<String> userNamesInUse;
  final bool isLoading;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  // var _isLoading = false;
  var _isLogin = true;
  var _isDj = false;

  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  bool _validateUserName(String userName) {
    if (widget.userNamesInUse.contains(userName)) {
      return true;
    }
    return false;
  }

  void _trySubmit() {
    // Run validation on TextFormFields
    final isValid = _formKey.currentState!.validate();

    // Close the soft keyboard
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _isLogin,
        _isDj,
        context,
      );
    }
    // Send auth request with user data
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                // Only take as much size as necessary
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin)
                    Column(
                      children: [
                        Text(
                          _isDj
                              ? 'I am an Entertainer'
                              : 'I am here to make song requests!!',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Switch.adaptive(
                          activeColor: Colors.purple,
                          value: _isDj,
                          onChanged: (val) {
                            setState(() {
                              _isDj = val;
                            });
                          },
                        ),
                      ],
                    ),
                  // Email
                  TextFormField(
                    key: const ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(labelText: 'Email address'),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  // Username
                  if (!_isLogin && _isDj)
                    TextFormField(
                      key: const ValueKey('username'),
                      autocorrect: false,
                      enableSuggestions: false,
                      validator: (value) {
                        var regex = value!.trim().replaceAll(' ', '-');

                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters.';
                        }

                        if (_validateUserName(value) ||
                            _validateUserName(regex)) {
                          print('Username already exists...');
                          return 'This username already exists. Please pick another';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Username'),
                      onSaved: (value) {
                        _userName = value!.toLowerCase();
                      },
                    ),
                  // Password
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading)
                    CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      child: Text(
                        _isLogin
                            ? 'Log In'
                            : (!_isDj
                                ? 'Sign Up For Free'
                                : 'Sign Up As Entertainer'),
                      ),
                      onPressed: _trySubmit,
                    ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (!widget.isLoading)
                    TextButton(
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
