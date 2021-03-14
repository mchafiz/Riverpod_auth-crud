import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_demo_firebase/models/Movie.dart';
import 'package:riverpod_demo_firebase/providers/auth_providers.dart';
import 'package:riverpod_demo_firebase/services/auth_services.dart';

class Database {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _movies;

  Future<bool> addNewMovie(Movie m) async {
    _movies = _firestore.collection('movies');
    try {
      await _movies.add({
        'id': m.uid,
        'name': m.movieName,
        'poster': m.posterURL,
        'length': m.length
      });
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> removeMovie(String movieId) async {
    _movies = _firestore.collection('movies');
    try {
      await _movies.doc(movieId).delete();
      return true;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<bool> editMovie(Movie m, String movieId) async {
    _movies = _firestore.collection('movies');
    try {
      await _movies.doc(movieId).update(
          {'name': m.movieName, 'poster': m.posterURL, 'length': m.length});
      return true;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }
}


// final dataProvider = StreamProvider.autoDispose<QuerySnapshot>((ref) {
//   try {
//     FirebaseFirestore _firestore = FirebaseFirestore.instance;
//     return _firestore.collection("movies").snapshots();
//   } catch (e) {
//     print(e.message);
//     return Stream.error(e.message);
//   }
// });

// final addMovieProvider =
//     FutureProvider.family.autoDispose((ref, Movie m) async {
//   final _dataProvider = ref.read(databaseProvider);
//   CollectionReference movies = FirebaseFirestore.instance.collection('movies');
//   try {
//     await _dataProvider.addNewMovie(m);
//     return true;
//   } catch (e) {
//     print(e.message);
//     return false;
//   }
// });
