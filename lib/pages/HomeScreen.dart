import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_demo_firebase/pages/AddMovie.dart';
import 'package:riverpod_demo_firebase/providers/auth_providers.dart';
import 'package:riverpod_demo_firebase/providers/database_providers.dart';
import 'package:riverpod_demo_firebase/providers/emailpassword_providers.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    // final database = context.read(databaseProvider);
    final auth = watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Riverpod Firebase Demo'), actions: [
        InkWell(
          onTap: () {
            context.read(authServiceProvider).signOut();
            context.read(emailprovider).state = '';
            context.read(passwordprovider).state = '';
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(Icons.logout),
          ),
        )
      ]),
      body: Center(
          child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('movies')
            .where('id', isEqualTo: auth.data!.value!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.error != null) {
            return Center(child: Text('Some error occurred'));
          }
          return MovieList(snapshot.data!.docs);
        },
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMovie()),
          );
        },
      ),
    );
  }
}

class MovieList extends ConsumerWidget {
  final List<QueryDocumentSnapshot> _movieList;
  MovieList(this._movieList);

  @override
  Widget build(BuildContext context, watch) {
    // final database = context.read(databaseProvider);
    final database = watch(databaseProvider);
    return _movieList.length != 0
        ? ListView.separated(
            itemCount: _movieList.length,
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemBuilder: (BuildContext context, int index) {
              final _currentMovie = _movieList[index].data();
              return Dismissible(
                background: slideRightBackground(),
                secondaryBackground: slideLeftBackground(),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    await Future.delayed(Duration(milliseconds: 300));
                    database.removeMovie(_movieList[index].id).then((res) {
                      if (res) {
                      } else {}
                    });
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditPage(
                                isFromEdit: true,
                                movie: _currentMovie,
                                documentId: _movieList[index].id,
                              )),
                    );
                  }
                },
                key: Key(_movieList[index].id),
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(_currentMovie!['poster']),
                  ),
                  title: Text(
                    _currentMovie['name'],
                  ),
                  subtitle: Text(_currentMovie['length']),
                  // trailing: IconButton(
                  //   icon: Icon(Icons.edit_outlined),
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => EditPage(
                  //                 isFromEdit: true,
                  //                 movie: _currentMovie,
                  //                 documentId: _movieList[index].id,
                  //               )),
                  //     );
                  //   },
                  // )
                ),
              );
            })
        : Center(child: Text('No Movies yet'));
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
