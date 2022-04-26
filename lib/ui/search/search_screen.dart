import 'package:flutter/material.dart';

import '../entertainer/entertainer_screen.dart';
import '../../routes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _entertainers = {};

  var _entertainerId = '';
  var _entertainerSearch = '';

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
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
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
      ),
    );
  }
}
