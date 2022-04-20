import 'package:flutter/material.dart';

class NewRequestForm extends StatefulWidget {
  const NewRequestForm(this.isLoading, this.submitFn, {Key? key})
      : super(key: key);

  final bool isLoading;
  final Future<void> Function(
    String artist,
    String title,
    String notes,
    BuildContext ctx,
  ) submitFn;

  @override
  State<NewRequestForm> createState() => _NewRequestFormState();
}

class _NewRequestFormState extends State<NewRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _artistController = TextEditingController();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _titleFocusNode = FocusNode();
  final _notesFocusNode = FocusNode();
  var _artist = '';
  var _title = '';
  var _notes = '';

  @override
  void dispose() {
    _artistController.dispose();
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _trySubmit() async {
    // Run validation on Artist & Title TextFormFields
    final isValid = _formKey.currentState!.validate();

    // Close the soft keyboard
    FocusScope.of(context).unfocus();

    if (isValid) {
      // Save Form Data
      _formKey.currentState!.save();

      // Call parent function
      widget.submitFn(
        _artist.trim(),
        _title.trim(),
        _notes.trim(),
        context,
      );

      // Clear TextFields
      _clearFields();
    }
  }

  void _clearFields() {
    _artistController.clear();
    _titleController.clear();
    _notesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Artist Input
                  TextFormField(
                    controller: _artistController,
                    key: const ValueKey('artist'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: true,
                    decoration: const InputDecoration(labelText: 'Artist'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_titleFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the artist\'s name.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _artist = value!;
                    },
                  ),
                  // Title Input
                  TextFormField(
                    controller: _titleController,
                    key: const ValueKey('title'),
                    focusNode: _titleFocusNode,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: true,
                    decoration: const InputDecoration(labelText: 'Song Title'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_notesFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the song title';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _title = value!;
                    },
                  ),
                  // Additional Notes
                  TextFormField(
                    controller: _notesController,
                    key: const ValueKey('notes'),
                    focusNode: _notesFocusNode,
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'It\'s my birthday',
                      labelText: 'Notes',
                    ),
                    onSaved: (value) {
                      _notes = value!;
                    },
                  ),

                  const SizedBox(height: 10),
                  // Send it!
                  TextButton.icon(
                    onPressed: _trySubmit,
                    icon: const Icon(
                      Icons.send,
                      size: 30,
                    ),
                    label: const Text(
                      'Send',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
