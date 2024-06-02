
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<Map<String, dynamic>> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {'user': userCredential.user, 'error': null};
    } on FirebaseAuthException catch(e){
      return {'user': null, 'error': e.toString()};
    }catch (e) {
      return {'user': null, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return {'user': userCredential.user, 'error': null};
    } catch (e) {
      return {'user': null, 'error': e.toString()};
    }
  }


  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
