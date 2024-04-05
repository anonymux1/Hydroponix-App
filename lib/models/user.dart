// models/user.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String? displayName;
  final String? email;
  final String? profilePhotoUrl;

  User({
    required this.uid,
    this.displayName,
    this.email,
    this.profilePhotoUrl,
  });

  // For Firestore data (add a factory constructor)
  User.fromFirestore(DocumentSnapshot doc)
      : uid = doc.id,
        displayName = doc['displayName'],
        email = doc['email'],
        profilePhotoUrl = doc['profilePhotoUrl'];

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'profilePhotoUrl': profilePhotoUrl,
    };
  }
}
