import 'package:Hydroponix/screens/NotificationsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Hydroponix/services/notifications_controller.dart';

class MyAccountScreen extends StatefulWidget {
  final RxString? profilePhotoUrl;
  const MyAccountScreen({Key? key, this.profilePhotoUrl}) : super(key: key);

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  final Rx<ImageProvider?> imageProvider = Rx(null);

  @override
  void initState() {
    super.initState();
    imageProvider.value = (widget.profilePhotoUrl?.value != null
            ? NetworkImage(widget.profilePhotoUrl!.value) // Ensure non-null
            : AssetImage('assets/images/profile_avatar.jpg'))
        as ImageProvider<Object>?;
    widget.profilePhotoUrl?.listen((value) {
      imageProvider.value = NetworkImage(value); // Direct update
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Account'),
        ),
        body: Center(
            // For initial layout, adjust later if needed
            child: Column(
          mainAxisAlignment:
              MainAxisAlignment.start, // Adjust as you refine the layout
          children: [
            // Profile Avatar and Name
            CircleAvatar(
              radius: 120, // Adjust the radius as needed
              backgroundImage: imageProvider.value,
            ),
            const SizedBox(height: 10),
            const Text(
              'User Name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildListTile('Notifications', Icons.notifications,
                      notificationCount: Get.find<NotificationController>()
                          .unreadNotificationCount),
                  _buildListTile('My Cart', Icons.shopping_cart,notificationCount: Get.find<NotificationController>()
                      .unreadNotificationCount),
                  _buildListTile('My Orders', Icons.receipt_long),
                  _buildListTile('Sign Out', Icons.logout),
                ],
              ),
            ),
          ],
        )));
  }

  Widget _buildListTile(String title, IconData icon, {int? notificationCount}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: notificationCount != null && notificationCount != 0
          ? Badge(
              label: Text(notificationCount.toString()),
              backgroundColor: Colors.red,
              textColor: Colors.white,
            )
          : null,
      onTap: () {
        // Handle navigation to the appropriate screen for each list item
        switch (title) {
          case 'Notifications':
        Get.to(() => NotificationsScreen());
        break;
          // ... handle other cases
          case 'Sign Out':
            _signOut();
            break;
        }
      },
    );
  }
  void _signOut() async {
    final confirmed = await Get.dialog(
      AlertDialog(
        title: Text('Confirm Sign Out'),
        content: Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false), // Cancel
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true), // Confirm
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
    if (confirmed ?? true) {
      try {
        await FirebaseAuth.instance.signOut();
        Get.back();
        // Example: Using Snackbars
        Get.snackbar(
          'SignOut Successful',
          'You have been signed out',
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        Get.snackbar(
          'SignOut Error',
          'An error occurred: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
