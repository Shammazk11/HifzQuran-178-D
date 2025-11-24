import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fypapp/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import './Home.dart';
import 'config.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: '1068984972054-veuki3c5q0c84eig01enlc8e9in0p5rk.apps.googleusercontent.com',
    forceCodeForRefreshToken: true,
  );

  // Custom SnackBar method
  void _showCustomSnackBar(BuildContext context, String message, {IconData? icon, bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon ?? (isError ? Icons.error_outline : Icons.check_circle_outline), color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade600 : const Color(0xFF13A795),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 6,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<User?> signUpWithGoogle(BuildContext context) async {
    try {
      print("Starting Google Sign In process...");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("Google Sign In cancelled by user");
        return null;
      }
      print("Google Sign In successful for: ${googleUser.email}");

      print("Getting Google Auth details...");
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print("Got access token: ${googleAuth.accessToken != null}");
      print("Got ID token: ${googleAuth.idToken != null}");

      print("Creating Firebase credential...");
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print("Signing in to Firebase...");
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        print("Firebase sign in successful for user: ${user.email}");
        try {
          await sendUserDataToBackend(context, user);
        } catch (e) {
          print("Backend communication failed but Firebase auth successful: $e");
        }
      } else {
        print("Firebase sign in failed - user is null");
      }

      return user;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.code} - ${e.message}");
      return null;
    } on Exception catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      print("Starting Google Sign In process...");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("Google Sign In cancelled by user");
        return null;
      }
      print("Google Sign In successful for: ${googleUser.email}");

      print("Getting Google Auth details...");
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print("Got access token: ${googleAuth.accessToken != null}");
      print("Got ID token: ${googleAuth.idToken != null}");

      print("Creating Firebase credential...");
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print("Signing in to Firebase...");
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        print("Firebase sign in successful for user: ${user.email}");
        try {
          await sendUserDataToBackendlogin(context, user);
        } catch (e) {
          print("Backend communication failed but Firebase auth successful: $e");
        }
      } else {
        print("Firebase sign in failed - user is null");
      }

      return user;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.code} - ${e.message}");
      return null;
    } on Exception catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  Future<void> sendUserDataToBackend(BuildContext context, User user) async {
    try {
      print("Sending user data to backend...");
      final Uri url = Uri.parse('${AppConfig.baseUrl}/googleregister');

      final userData = {
        "name": user.displayName,
        "email": user.email,
        "photoUrl": user.photoURL,
        "uid": user.uid,
      };
      print("Sending data: ${json.encode(userData)}");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(userData),
      );

      print("Backend response status: ${response.statusCode}");
      print("Backend response body: ${response.body}");

      if (response.statusCode == 200) {
        Provider.of<UserProvider>(context, listen: false).setEmail(user.email!);
        _showCustomSnackBar(context, "Signed up successfully!", icon: Icons.check_circle_outline);
        await Future.delayed(const Duration(seconds: 2));
        if (context.mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
        }
      } else if (response.statusCode == 400) {
        _showCustomSnackBar(context, "Account already exists", isError: true);
      } else {
        _showCustomSnackBar(
          context,
          "Failed to sign up: Server error ${response.statusCode}",
          isError: true,
        );
      }
    } catch (e) {
      print("Backend Error: $e");
      _showCustomSnackBar(context, "Error: Failed to connect to server", isError: true);
    }
  }

  Future<void> sendUserDataToBackendlogin(BuildContext context, User user) async {
    try {
      print("Sending user data to backend...");
      final Uri url = Uri.parse('${AppConfig.baseUrl}/googlelogin');

      final userData = {
        "name": user.displayName,
        "email": user.email,
        "photoUrl": user.photoURL,
        "uid": user.uid,
      };
      print("Sending data: ${json.encode(userData)}");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(userData),
      );

      print("Backend response status: ${response.statusCode}");
      print("Backend response body: ${response.body}");

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        String userEmail = jsonResponse["user"]["email"];
        Provider.of<UserProvider>(context, listen: false).setEmail(userEmail);
        _showCustomSnackBar(context, "Logged in successfully!", icon: Icons.check_circle_outline);
        await Future.delayed(const Duration(seconds: 2));
        if (context.mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
        }
      } else if (response.statusCode == 400) {
        _showCustomSnackBar(context, "Account already exists", isError: true);
      } else {
        _showCustomSnackBar(
          context,
          "Failed to login: Server error ${response.statusCode}",
          isError: true,
        );
      }
    } catch (e) {
      print("Backend Error: $e");
      _showCustomSnackBar(context, "Error: Failed to connect to server", isError: true);
    }
  }

  Future<void> signOut() async {
    try {
      print("Starting sign out process...");
      await _auth.signOut();
      await _googleSignIn.signOut();
      print("Sign out successful");
    } catch (e) {
      print("Sign out error: $e");
      throw e;
    }
  }
}