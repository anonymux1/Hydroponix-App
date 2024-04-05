import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:Hydroponix/screens/NotificationsScreen.dart';
import 'package:Hydroponix/services/notifications_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Hydroponix/screens/MyAccountScreen.dart';
import '../services/navigation_controller.dart';
//import 'package:http/http.dart' as http;
//import 'dart:io';

// Replace with your actual imports for camera, navigation

class TitleBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final NavigationController navigationController; // Add this
  TitleBarWidget({Key? key, required this.navigationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? _buildWebAppBar(context)
        : _buildMobileAppBar(context);
  }

  Widget _buildWebAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row( // Left-aligned Hydroponix icon and title
            children: [
              const Icon(Icons.grass), // Placeholder icon
              const SizedBox(width: 10),
              const Text('Hydroponix'),
            ],
          ),
          Row( // Right-aligned icons (camera, notification, profile)
            children: [
              IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () => _handleCameraIconPressed(context),
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () => _handleNotificationsIconPressed(context),
                  ),
                  GetBuilder<NotificationController>(
                      builder: (controller) {
                        return Badge(
                          label: Text(
                              controller.unreadNotificationCount.toString()),
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          alignment: Alignment.topRight,
                          isLabelVisible: controller.unreadNotificationCount >
                              0,
                        );
                      }
                  )
                ],
              ),
              GetBuilder<NavigationController>(
                builder: (controller) {
                  return GestureDetector(
                    onTap: () => _handleProfileAvatarPressed(context),
                    child: controller.profilePhotoUrl.isNotEmpty
                        ? CircleAvatar(
                      backgroundImage: NetworkImage(
                          controller.profilePhotoUrl.value),
                    )
                        : CircleAvatar(
                      backgroundImage:
                      AssetImage('assets/images/profile_avatar.jpg'),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileAppBar(BuildContext context) {
    return AppBar(
      title: Row( // Left-aligned Hydroponix icon and title
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.grass), // Placeholder icon
          const SizedBox(width: 10),
          const Text('Hydroponix'),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.camera_alt),
          onPressed: () => _handleCameraIconPressed(context),
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () => _handleNotificationsIconPressed(context),
            ),
            GetBuilder<NotificationController>(
                builder: (controller) {
                  return Badge(
                    label: Text(controller.unreadNotificationCount.toString()),
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    alignment: Alignment.topRight,
                    isLabelVisible: controller.unreadNotificationCount > 0,
                  );
                }
            )
          ],
        ),
        GetBuilder<NavigationController>(
          builder: (controller) {
            return GestureDetector(
              onTap: () => _handleProfileAvatarPressed(context),
              child: controller.profilePhotoUrl.isNotEmpty
                  ? CircleAvatar(
                backgroundImage: NetworkImage(controller.profilePhotoUrl.value),
              )
                  : CircleAvatar(
                backgroundImage:
                AssetImage('assets/images/profile_avatar.jpg'),
              ),
            );
          },
        ),
      ],
    );
  }

  void _handleCameraIconPressed(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera, // Use the camera
        // Optional parameters for image quality:
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        // Do something with the image file (display, upload, etc.)
        print('Image Path: ${pickedFile.path}'); // Example usage
      }
    } catch (e) {
      // Handle any errors
      print('Error while picking image: $e');
    }
  }

  void _handleNotificationsIconPressed(BuildContext context) {
    Get.to(() =>
        NotificationsScreen()); // Assuming you've created a NotificationsScreen widget
  }

  void _handleProfileAvatarPressed(BuildContext context) {
    Get.to(() => MyAccountScreen(profilePhotoUrl: navigationController.profilePhotoUrl));
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
