import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_demo_firebase/pages/HomeScreen.dart';
import 'package:riverpod_demo_firebase/pages/login.dart';
import 'package:riverpod_demo_firebase/providers/auth_providers.dart';

void main() async {
  // don't mess up the order of the steps here
  WidgetsFlutterBinding
      .ensureInitialized(); // Very Important to do (Reason below)
  await Firebase.initializeApp(); // this connects our app with Firebase
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase CRUD Demo',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  StartPage({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child:
                Text('Something error or wrong, please check your connection'),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          return AuthCheck();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class AuthCheck extends ConsumerWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, watch) {
    final auth = watch(authStateProvider);

    return auth.when(
        data: (value) {
          if (value != null) {
            print('coba' + value.toString());
            return HomeScreen();
          } else {
            print('coba' + value.toString());

            return LoginPage();
          }
        },
        loading: () => Center(
              child: CircularProgressIndicator(),
            ),
        error: (e, stack) => Center(
              child: Text('error login'),
            ));
  }
}
