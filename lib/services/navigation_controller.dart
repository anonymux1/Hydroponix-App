import 'package:get/get.dart';

class NavigationController extends GetxController {
  final _currentPageIndex = 0.obs;
  int get currentPageIndex => _currentPageIndex.value;
  final profilePhotoUrl = RxString(''); // Reactive profile photo URL

  void changePageIndex(int newIndex) {
    _currentPageIndex.value = newIndex;
  }
}