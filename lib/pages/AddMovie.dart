import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_demo_firebase/models/Movie.dart';
import 'package:riverpod_demo_firebase/providers/auth_providers.dart';
import 'package:riverpod_demo_firebase/providers/database_providers.dart';

class AddMovie extends ConsumerWidget {
  AddMovie({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, watch) {
    final auth = watch(authStateProvider);
    final _formKey = GlobalKey<FormState>();
    String _name = '', _posterURL = '', _length = '', _error = '';

    return Scaffold(
        appBar: AppBar(
          title: Text('Add a movie'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Movie name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Name can be empty !';
                        }
                        return null;
                      },
                      initialValue: '',
                      onChanged: (val) {
                        _name = val;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Movie poster url',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'poster can be empty !';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        _posterURL = val;
                      },
                      initialValue: '',
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Movie length',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Movie length can be empty !';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        _length = val;
                      },
                      initialValue: '',
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.add),
                        label: Text('Add'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final response = context.read(databaseProvider);

                            try {
                              Movie _m = new Movie(_name, _posterURL, _length,
                                  auth.data!.value!.uid);

                              await response.addNewMovie(_m);

                              final successSnackbar = SnackBar(
                                content: Text('Added Successfully !'),
                                duration: Duration(seconds: 2),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(successSnackbar)
                                  .closed
                                  .then((data) => {Navigator.pop(context)});
                            } catch (e) {
                              final failureSnackbar =
                                  SnackBar(content: Text('Error : $_error'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(failureSnackbar);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class EditPage extends ConsumerWidget {
  final bool isFromEdit;
  final String documentId;

  final Map<String, dynamic>? movie;

  const EditPage(
      {Key? key,
      required this.isFromEdit,
      required this.documentId,
      required this.movie})
      : super(key: key);

  @override
  Widget build(BuildContext context, watch) {
    final auth = watch(authStateProvider);
    final _formKey = GlobalKey<FormState>();
    String name = movie?['name'],
        posterURL = movie?['poster'],
        length = movie?['length'];
    return Scaffold(
        appBar: AppBar(title: Text('Edit a movie')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Movie name',
                      ),
                      initialValue: movie?['name'],
                      onChanged: (val) {
                        name = val;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Movie poster url',
                      ),
                      initialValue: movie?['poster'],
                      onChanged: (val) {
                        posterURL = val;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Movie length',
                      ),
                      initialValue: movie?['length'],
                      onChanged: (val) {
                        length = val;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.edit),
                        label: Text('Edit'),
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            try {
                              final response = context.read(databaseProvider);

                              Movie _m = new Movie(name, posterURL, length,
                                  auth.data!.value!.uid);

                              await response.editMovie(_m, documentId);
                              final successSnackbar = SnackBar(
                                content: Text('Edited Successfully !'),
                                duration: Duration(seconds: 2),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(successSnackbar)
                                  .closed
                                  .then((data) => {Navigator.pop(context)});
                            } catch (e) {
                              final failureSnackbar =
                                  SnackBar(content: Text('Error : $e'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(failureSnackbar);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
