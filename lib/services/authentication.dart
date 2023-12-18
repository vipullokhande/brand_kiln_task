import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> createUser({
    required String email,
    required String password,
  }) async {
    String res = '';
    try {
      // ignore: unused_local_variable
      UserCredential? cred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      res = 'success';
      //
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = '';
    try {
      final auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(email: email, password: password);
      res = 'success';
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      res = e.toString();
    }
    return res;
  }
}
