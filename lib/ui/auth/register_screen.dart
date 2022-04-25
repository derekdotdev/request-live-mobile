import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_localizations.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../resources/firestore_database.dart';
import '../../routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();
  final _isEntertainerValue = false;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _usernameController;
  late List<String> _usernamesInUse = [];
  late var _isLoading = false;
  late bool _isInit;

  @override
  void initState() {
    _isLoading = true;
    _isInit = true;
    super.initState();
    _emailController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
    _usernameController = TextEditingController(text: '');
    _isLoading = false;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      print('_fetchUserNamesInUse() called from didChangeDependencies()');
      _usernamesInUse = await _fetchUserNamesInUse();
      _isInit = false;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _usernamesInUse.clear();
    super.dispose();
  }

  Future<List<String>> _fetchUserNamesInUse() async {
    print('_fetchUserNamesInUse() called!');
    List<String> usernames = [];
    var currentUsername = '';
    await FirebaseFirestore.instance
        .collection('usernames')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        currentUsername = element['username'].toString();
        usernames.add(currentUsername);
      });
    });

    print('Fetched Usernames: ');
    for (String s in usernames) {
      print(s);
    }
    return usernames;
  }

  bool _checkUsernameAvailable(String username) {
    if (_usernamesInUse.contains(username)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : Stack(
              children: <Widget>[
                // _buildBackground(),
                Align(
                  alignment: Alignment.center,
                  child: _buildForm(context),
                ),
              ],
            ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: FlutterLogo(
                  size: 128,
                ),
              ),
              // Email
              TextFormField(
                controller: _emailController,
                autocorrect: false,
                enableSuggestions: false,
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.emailAddress,
                style: Theme.of(context).textTheme.bodyText2,
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)
                        .translate("loginTxtErrorEmail")
                    : null,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    labelText:
                        AppLocalizations.of(context).translate("loginTxtEmail"),
                    border: const OutlineInputBorder()),
              ),
              // Username
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextFormField(
                  controller: _usernameController,
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  style: Theme.of(context).textTheme.bodyText2,
                  validator: (value) {
                    bool available = _checkUsernameAvailable(value!);
                    if (!available) {
                      return AppLocalizations.of(context)
                          .translate("loginTxtErrorUsername");
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.account_circle_rounded,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      labelText: AppLocalizations.of(context)
                          .translate("loginTxtUsername"),
                      border: const OutlineInputBorder()),
                ),
              ),
              // Password
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextFormField(
                  obscureText: true,
                  maxLength: 12,
                  controller: _passwordController,
                  style: Theme.of(context).textTheme.bodyText2,
                  validator: (value) => value!.length < 7
                      ? AppLocalizations.of(context)
                          .translate("loginTxtErrorPassword")
                      : null,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      labelText: AppLocalizations.of(context)
                          .translate("loginTxtPassword"),
                      border: const OutlineInputBorder()),
                ),
              ),
              authProvider.status == Status.registering
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : TextButton(
                      child: Text(
                        AppLocalizations.of(context)
                            .translate("loginBtnSignUp"),
                        style: Theme.of(context).textTheme.button,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context)
                              .unfocus(); //to hide the keyboard - if any

                          UserModel userModel =
                              await authProvider.registerWithEmailAndPassword(
                                  _emailController.text,
                                  _passwordController.text,
                                  _usernameController.text,
                                  _isEntertainerValue);

                          if (userModel.uid == 'null') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(AppLocalizations.of(context)
                                  .translate("loginTxtErrorSignIn")),
                            ));
                          } else {
                            Navigator.of(context)
                                .pushReplacementNamed(Routes.welcome);
                          }
                        }
                      },
                    ),
              authProvider.status == Status.registering
                  ? const Center(
                      child: null,
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: Center(
                          child: Text(
                        AppLocalizations.of(context)
                            .translate("loginTxtHaveAccount"),
                        style: Theme.of(context).textTheme.button,
                      )),
                    ),
              authProvider.status == Status.registering
                  ? const Center(
                      child: null,
                    )
                  : TextButton(
                      child: Text(
                        AppLocalizations.of(context)
                            .translate("loginBtnLinkSignIn"),
                        style: TextStyle(
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(Routes.login);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return ClipPath(
      clipper: SignInCustomClipper(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}

class SignInCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);

    var firstEndPoint = Offset(size.width / 2, size.height - 95);
    var firstControlPoint = Offset(size.width / 6, size.height * 0.45);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height / 2 - 50);
    var secondControlPoint = Offset(size.width, size.height + 15);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
