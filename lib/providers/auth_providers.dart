import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_demo_firebase/services/auth_services.dart';

// nge instace firebase authnya, bisa di instance di class authenticationservice sih
//tapi au anak yutuber maunya disini ikutin ajadah
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
//trus ini buat dipanggil di class class lain, biar fungsi atau method didalam class
//authenticationservice nya itu bisa di panggil, constructornya manggil firebaseauth.instance
//biar fungsi didalam class authenticationservice berjalan normal.
final authServiceProvider = Provider<AuthenticationService>(
    (ref) => AuthenticationService(ref.read(firebaseAuthProvider)));

// untuk cek apakah di aplikasi terdapat akun yang sign atau tidak
final authStateProvider = StreamProvider<User?>(
    (ref) => ref.watch(authServiceProvider).authStateChange);
