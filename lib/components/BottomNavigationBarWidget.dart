import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/navigation_controller.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({Key? key, required this.onItemTapped}) : super(key: key);

final Function(int) onItemTapped; // Type of the callback function

@override
  _BottomNavigationBarWidgetState createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {

  void _onItemTapped(int index) {
    Get.find<NavigationController>().changePageIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(
        builder: (controller) { // GetBuilder for reactivity
          return BottomNavigationBar(
            currentIndex: controller.currentPageIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.teal[900],
            // Selected item color
            unselectedItemColor: Colors.grey,
            // Color for unselected items
            backgroundColor: Colors.white,
            // Background color

            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.grass), label: "Systems"),
              BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Analyze"),
              BottomNavigationBarItem(icon: Icon(Icons.shop), label: "Shop"),
            ],
          );
        }
    );
  }
}