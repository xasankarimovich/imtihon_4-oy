import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth authService = FirebaseAuth.instance;

  Future<void> login(String email, String password) async {
    try {
      await authService.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      print(email);
      print(password);
      final credentials =  await authService.createUserWithEmailAndPassword(email: email, password: password);
      print("CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCc");
      print(credentials);

    } catch (e) {
      print("EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
      print(e);
      rethrow;
    }
  }

  Future<void> logout() async {
    await authService.signOut();
  }
}
