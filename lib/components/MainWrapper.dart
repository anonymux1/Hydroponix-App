
import 'package:Hydroponix/screens/ShopScreen.dart';
import 'package:Hydroponix/screens/HomeScreen.dart';
import 'package:Hydroponix/screens/SystemsScreen.dart';
import 'package:Hydroponix/screens/AnalyzeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'BottomNavigationBarWidget.dart';
import 'TitleBarWidget.dart';
import 'package:Hydroponix/services/navigation_controller.dart';

class MainWrapper extends StatelessWidget {
  MainWrapper({Key? key, this.profilePhotoUrl}) : super(key: key);
  final String? profilePhotoUrl;
  final navigationController = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    if (profilePhotoUrl != null) {
      navigationController.profilePhotoUrl.value = profilePhotoUrl!; // Update controller
    }
    return Scaffold(
      appBar: TitleBarWidget(navigationController: navigationController),
      body: Obx(() { // Obx wraps only body and navigation
        return Column(
          children: [
            Expanded(child: _buildCurrentScreen()), // Adjusted for layout
            BottomNavigationBarWidget(
                onItemTapped: (newIndex) => navigationController.changePageIndex(newIndex)
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCurrentScreen() {
    switch (navigationController.currentPageIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return const SystemsScreen();
      case 2:
        return const AnalyzeScreen();
      case 3:
        return const ShopScreen();
      default:
        return HomeScreen(); // Fallback
    }
  }
}