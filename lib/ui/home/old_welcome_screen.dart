import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../../app_localizations.dart';
import '../../constants/global_variables.dart';
import '../../resources/firestore_database.dart';
import '../drawer/app_drawer.dart';
import '../entertainer/entertainer_screen.dart';
import '../../routes.dart';
import '../../providers/auth_provider.dart';
import '../../constants/colors.dart';

class WelcomeScreen extends StatefulWidget {
  // static const routeName = '/welcome';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _page = 0;
  late PageController pageController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _entertainers = {};

  late bool _isInit;
  final _isLoading = false;
  var _entertainerId = '';
  var _entertainerSearch = '';

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _isInit = true;
  }

  @override
  void dispose() {
    // TODO verify if page controller should be disposed before or after super().
    pageController.dispose();
    super.dispose();
  }

  // Submit search function
  void _trySubmitEntertainerSearch() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();
      var entertainerFound =
          _entertainers.containsValue(_entertainerSearch.trim().toLowerCase());

      if (entertainerFound) {
        // Get entertainer uid for entertainer name
        _entertainerId = _entertainers.keys
            .firstWhere((k) => _entertainers[k] == _entertainerSearch);

        Navigator.pushNamed(
          context,
          Routes.entertainer,
          arguments: EntertainerScreenArgs(
            _entertainerId,
            _entertainerSearch.trim(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Unable to find an entertainer with that name. Please try again...'),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      backgroundColor: Colors.white,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              title: StreamBuilder(
                stream: authProvider.user,
                builder: (context, snapshot) {
                  // final UserModel? user = snapshot.data as UserModel?;
                  return const Text('homeAppBarTitle');
                },
              ),
            ),
      drawer: AppDrawer(),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to Request Live!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            key: const ValueKey('search'),
                            autocorrect: false,
                            validator: (value) {
                              if (value == null) {
                                return 'Entry cannot be blank!';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              label: Center(
                                child: Text(
                                    'Search for an entertainer to start making requests!'),
                              ),
                            ),
                            textAlign: TextAlign.center,
                            onSaved: (value) {
                              if (value != null) {
                                _entertainerSearch = value;
                              }
                            },
                          ),
                        ),
                        TextButton(
                          child: const Text('Search'),
                          onPressed: _trySubmitEntertainerSearch,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: (_page == 0) ? primaryColor : secondaryColor),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,
                color: (_page == 1) ? primaryColor : secondaryColor),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: (_page == 2) ? primaryColor : secondaryColor),
            label: '',
            backgroundColor: primaryColor,
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
