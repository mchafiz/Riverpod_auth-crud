import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_demo_firebase/providers/auth_providers.dart';
import 'package:riverpod_demo_firebase/providers/emailpassword_providers.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, watch) {
    final _email = watch(emailprovider).state;
    final _password = watch(passwordprovider).state;
    final _auth = watch(authServiceProvider);

    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Register account',
            style: Theme.of(context).textTheme.headline3!.apply(
                  color: Colors.white,
                  fontWeightDelta: 20,
                ),
          ),
          TextField(
            onChanged: (v) {
              context.read(emailprovider).state = v;
            },
            decoration: InputDecoration(hintText: 'Email'),
          ),
          TextField(
            onChanged: (v) {
              context.read(passwordprovider).state = v;
            },
            decoration: InputDecoration(hintText: 'Password'),
          ),
          ElevatedButton(
              onPressed: () {
                _auth.signUp(
                  email: _email,
                  password: _password,
                );
              },
              child: Text('sign-in'))
        ],
      )),
    );
  }
}
