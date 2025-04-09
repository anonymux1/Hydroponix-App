import 'package:Hydroponix/components/MainWrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_config.dart';
import 'package:Hydroponix/models/User.dart' as AppUser;

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
              GoogleProvider(clientId: Get.find<AppConfig>().clientId),
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('assets/flutterfire_300x.png'),
                ),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                    ? const Text('Welcome to FlutterFire, please sign in!')
                    : const Text('Welcome to Flutterfire, please sign up!'),
              );
            },
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'By signing in, you agree to our terms and conditions.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                final user = state.user;
                _checkAndCreateFirestoreUser(user);
              }),
              AuthStateChangeAction<AuthState>((context, state) {
                // Log the error
                if(state is AuthFailed)
                print('Sign in failed: ${state.exception}');
              }),
            ],
          );
        }
    else {
          final user = snapshot.data; // Access the user object
          _checkAndCreateFirestoreUser(user); // Call helper function
          final profilePhotoUrl = user?.photoURL; // Get the photo URL
          return MainWrapper(profilePhotoUrl: profilePhotoUrl);
        }
      },
    );
  }
  Future<void> _checkAndCreateFirestoreUser(User? firebaseUser) async {
    if (firebaseUser != null) {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('users').doc(firebaseUser.uid);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        // Create a new User object and save it to Firestore
        final user = AppUser.User(
          uid: firebaseUser.uid,
          displayName: firebaseUser.displayName,
          email: firebaseUser.email,
          profilePhotoUrl: firebaseUser.photoURL,
        );
        await docRef.set(user.toMap()); // Use the toMap() method
      }
    }
  }
}
