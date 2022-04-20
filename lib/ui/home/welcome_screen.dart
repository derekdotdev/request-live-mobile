import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../../app_localizations.dart';
import '../drawer/app_drawer.dart';
import '../entertainer/entertainer_screen.dart';
import '../../routes.dart';
import '../../providers/auth_provider.dart';

class WelcomeScreen extends StatefulWidget {
  // static const routeName = '/welcome';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   // Only load entertainer usernames at first login
  //   // TODO this may cause problems later..consider provider.of<Entertainer>(ctx)
  //   if (_isInit) {
  //     fetchEntertainerUserNames();
  //   }
  //
  //   _isInit = false;
  // }

  // Get list of entertainers from database
  // TODO There has to be a better way...Right?
  // Future<void> fetchEntertainerUserNames() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   // await FirebaseFirestore.instance.collection('users').get().then(
  //   //       (querySnapshot) => {
  //   //         for (var doc in querySnapshot.docs)
  //   //           {
  //   //             if (doc.data()['isDj'] == true)
  //   //               {
  //   //                 _entertainers.putIfAbsent(
  //   //                     doc.id, () => doc.data()['username']),
  //   //                 print(doc.data()['username'].toString()),
  //   //               },
  //   //           },
  //   //       },
  //   //     );
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
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
    );
  }
}
