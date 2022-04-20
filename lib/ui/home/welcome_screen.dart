import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../entertainer/entertainer_screen.dart';

import '../app_drawer.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/welcome';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _entertainers = {};

  late bool _isInit;
  var _isLoading = false;
  var _entertainerId = '';
  var _entertainerSearch = '';

  @override
  void initState() {
    super.initState();
    _isInit = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Only load entertainer usernames at first login
    // TODO this may cause problems later..consider provider.of<Entertainer>(ctx)
    if (_isInit) {
      fetchEntertainerUserNames();
    }

    _isInit = false;
  }

  // Get list of entertainers from database
  // TODO There has to be a better way...Right?
  Future<void> fetchEntertainerUserNames() async {
    setState(() {
      _isLoading = true;
    });

    await FirebaseFirestore.instance.collection('users').get().then(
          (querySnapshot) => {
            for (var doc in querySnapshot.docs)
              {
                if (doc.data()['isDj'] == true)
                  {
                    _entertainers.putIfAbsent(
                        doc.id, () => doc.data()['username']),
                    print(doc.data()['username'].toString()),
                  },
              },
          },
        );
    setState(() {
      _isLoading = false;
    });
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
          EntertainerScreen.routeName,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Request Live'),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(Icons.exit_to_app),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
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
                              if (value!.trim().isEmpty &&
                                  !value.contains('1')) {
                                return 'Entry cannot be blank!';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              label: const Center(
                                child: Text(
                                    'Search for an entertainer to start making requests!'),
                              ),
                            ),
                            textAlign: TextAlign.center,
                            onSaved: (value) {
                              _entertainerSearch = value!;
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
    );
  }
}
