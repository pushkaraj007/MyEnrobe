import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;

  Future<void> signInWithEmailAndPassword(String username, String password) async {
    try {
      final userQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        final userDocument = userQuerySnapshot.docs.first;
        final userEmail = userDocument['email'];

        await _auth.signInWithEmailAndPassword(
          email: userEmail,
          password: password,
        );
      } else {
        throw Exception('User not found. Please enter a valid username.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw Exception('Password is incorrect');
      } else {
        throw Exception('Username or password incorrect');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
