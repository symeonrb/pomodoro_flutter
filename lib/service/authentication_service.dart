import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  const AuthenticationService();

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    final googleProvider = GoogleAuthProvider();
    final credential =
        (await FirebaseAuth.instance.signInWithPopup(googleProvider))
            .credential;
    if (credential == null) return;

    await _firebaseAuth.signInWithCredential(credential);
  }
}
