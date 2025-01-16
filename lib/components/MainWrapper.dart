import 'package:Hydroponix/screens/ShopScreen.dart';
import 'package:Hydroponix/screens/HomeScreen.dart';
import 'package:Hydroponix/screens/SystemsScreen.dart';
import 'package:Hydroponix/screens/AnalyzeScreen.dart';
import 'package:Hydroponix/services/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'BottomNavigationBarWidget.dart';
import 'TitleBarWidget.dart';
import 'package:Hydroponix/services/navigation_controller.dart';

class MainWrapper extends StatelessWidget {
  MainWrapper({Key? key, this.profilePhotoUrl}) : super(key: key);
  final String? profilePhotoUrl;
  final navigationController = Get.put(NavigationController());
  final cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    if (profilePhotoUrl != null) {
      navigationController.profilePhotoUrl.value =
      profilePhotoUrl!; // Update controller
    }
    return Scaffold(
      appBar: TitleBarWidget(navigationController: navigationController, cartController: cartController),
      body:
      Obx(() {
        return (navigationController.fetchingSystems.value ?
        const Column(
            children: [
              Expanded(child: Center(child: CircularProgressIndicator())),
            ]) :
          Column(
          children: [
            Expanded(
                child: _buildCurrentScreen()), // Adjusted for layout
            BottomNavigationBarWidget(
                onItemTapped: (newIndex) =>
                    navigationController.changePageIndex(newIndex)),
          ],
        ));
      }),
    );
  }
  Widget _buildCurrentScreen() {
    if (navigationController.fetchingSystems.value) {
      // Show a loading indicator until data is fetched
      return const Center(child: CircularProgressIndicator());
    }
    switch (navigationController.currentPageIndex) {
      case 0:
        return  HomeScreen(
            navigationController.userSystemList,
            navigationController.allSysLogs,
            navigationController.latestReadings);
      case 1:
        return SystemsScreen(
            navigationController.userSystemList,
            navigationController.allSysLogs,
            navigationController.latestReadings,
            navigationController.newClient);
      case 2:
        return AnalyzeScreen(
            navigationController.userSystemList,
            navigationController.allSysLogs,
            navigationController.latestReadings);
      case 3:
        return const ShopScreen();
      default:
        return HomeScreen(
            navigationController.userSystemList,
            navigationController.allSysLogs,
            navigationController.latestReadings);
    }
  }
}
