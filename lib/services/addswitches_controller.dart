import 'package:get/get.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:http/http.dart' as http; // For API calls


class AddSwitchesController extends GetxController {
  var availableNetworks = <WiFiAccessPoint>[].obs;
  var selectedNetwork = ''.obs;
  var switchSSID = ''.obs;
  var switchPassword = ''.obs;


  @override
  void onInit() {
    super.onInit();
    scanForNetworks();
  }

  Future<void> scanForNetworks() async {
    final canScan = await WiFiScan.instance.canStartScan(askPermissions: true);
    if (canScan == CanStartScan.yes) {
      await WiFiScan.instance.startScan();
      availableNetworks.value = await WiFiScan.instance.getScannedResults();
      // Filter out networks that are not Hydroponix
      availableNetworks.value = availableNetworks
          .where((network) => network.ssid.contains("Hydroponix"))
          .toList();
    } else {
      // Handle the case where scanning is not possible
      Get.snackbar("Error", "Wi-Fi scanning is not supported on this device.");
    }
  }

  Future<void> connectToSwitchAP(String ssid) async {
    await WiFiForIoTPlugin.connect(ssid, security: NetworkSecurity.NONE);
  }

  Future<void> sendConfigurationData() async {
    // Implement the logic to send SSID and password to the switch
    final url = Uri.http('192.168.1.1', '/config');
    final body = {
      'ssid': switchSSID.value,
      'password': switchPassword.value,
    };
    try {
      final response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        // Handle success
        Get.snackbar("Success", "Configuration sent successfully.");
      } else {
        // Handle error
        Get.snackbar("Error", "Failed to send configuration.");
      }
    } catch (e) {
      Get.snackbar("Error", "Network error: $e");
    }
  }

  Future<void> reconnectToMainSystemAP() async {
    // Implement the logic to reconnect to the main system's AP

  }
}