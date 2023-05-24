import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static UserCredential? userCredential;
  static final auth = FirebaseAuth.instance;
  static User? get currentUser => auth.currentUser;

  static Future<UserCredential> loginWithEmailPass(
      String email, String password) async {
    final credential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return credential;
  }

  static Future<void> logout() async {
    return auth.signOut();
  }

  static Future<UserCredential> signInWithEmailPass(
      String email, String password) async {
    final credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return credential;
  }

  static Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential!;
  }

  static Future<void> forgotPassword(String email) async {
    return await auth.sendPasswordResetEmail(email: email);
  }
}
