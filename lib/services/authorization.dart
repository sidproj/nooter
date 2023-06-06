import 'package:firebase_auth/firebase_auth.dart';

class Authorization {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {"user": result.user, "error": null};
    } on FirebaseAuthException catch (e) {
      final Map<dynamic, dynamic> response = Map();

      response['user'] = null;

      if (e.code == "user-not-found") {
        response['error'] = "No account with such email!";
      } else if (e.code == "wrong-password") {
        response['error'] = "Incorrect password!";
      } else {
        response['error'] = "Unknown error!";
      }
      print(e.code);
      return response;
    }
  }

  Future register(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {'user': result.user, 'error': null};
    } on FirebaseAuthException catch (e) {
      final Map<dynamic, dynamic> response = Map();

      response['user'] = null;

      if (e.code == "email-already-in-use") {
        response['error'] = "Email is already in use";
      } else {
        response['error'] = "Unknown error!";
      }
      print(e.code);
      return response;
    }
  }
}
