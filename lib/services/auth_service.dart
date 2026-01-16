import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  /// Sign in with Google - returns User or null on failure
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      // Obtain auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential result = await _auth.signInWithCredential(credential);
      print('AuthService: Signed in as ${result.user?.displayName}');
      return result.user;
    } catch (e) {
      print('AuthService: Google Sign-In failed: $e');
      return null;
    }
  }

  /// Sign in anonymously (fallback if Google fails)
  Future<User?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return result.user;
    } catch (e) {
      print('AuthService: Anonymous sign-in failed: $e');
      return null;
    }
  }

  /// Sign out from both Firebase and Google
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('AuthService: Sign out failed: $e');
    }
  }
}
