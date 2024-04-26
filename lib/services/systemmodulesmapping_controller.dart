import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SystemModulesMappingController extends GetxController {

  Future<String> _getUserId() async {
    // Retrieve the userId from Firebase Authentication
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception('User not signed in'); // Handle this appropriately
    }
  }
}
