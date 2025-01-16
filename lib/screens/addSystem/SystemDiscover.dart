import 'package:Hydroponix/models/SystemList.dart';
import 'package:Hydroponix/screens/addSystem/SystemInfo.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:get/get.dart';


class SystemDiscoverScreen extends StatefulWidget {
  final SystemList? userSystems;
  const SystemDiscoverScreen(this.userSystems, {Key? key}) : super(key: key); // Constructor

  @override
  _SystemDiscoverScreenState createState() => _SystemDiscoverScreenState();
}

class _SystemDiscoverScreenState extends State<SystemDiscoverScreen> {
  var isDeviceFound = false.obs;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndScan();
  }

  Future<void> _checkPermissionsAndScan() async {
    // 1. Check Existing Permissions
    var permissionStatus = await Permission.location.status;
    if (permissionStatus.isGranted) {
      _scanForDevice();
    } else {
      // 2. Request Permissions
      var statuses = await [Permission.location].request();
      if (statuses[Permission.location]!.isGranted) {
        _scanForDevice();
      } else {
        // Handle permission denial
        // Display an error message or instructions to the user'
        // take user to settings
      }
    }
  }

  Future<void> _scanForDevice() async {
    try {
      // Check for Wi-Fi connectivity
      var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult != ConnectivityResult.wifi) {
        //TODO - take user to settings
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Wi-Fi Disabled"),
            content: Text(
                "Please enable Wi-Fi in your device settings to continue."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Dismiss the dialog
                child: Text("OK"),
              ),
            ],
          ),
        );
        return; // Stop the scan process
      }

      // Check if scanning is supported
      final canScan =
          await WiFiScan.instance.canStartScan(askPermissions: true);
      if (canScan != CanStartScan.yes) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Scanning Error"),
            content: Text(
                "Either Wi-Fi scanning is not supported on your device or necessary permissions are not granted."), // Adjust this message as needed
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
        return;
      }

      // Get Scan Results
      List<WiFiAccessPoint> accessPoints =
          await WiFiScan.instance.getScannedResults();

      // Find Hydroponix Network
      var hydroNetwork = accessPoints
          .firstWhereOrNull((network) => network.ssid == "Hydroponix");

      if (hydroNetwork != null) {
        isDeviceFound.value = true;
        // Attempt connection to Hydroponix network
        await WiFiForIoTPlugin.connect(hydroNetwork.ssid,
            security: NetworkSecurity.NONE);
        // await Future.delayed(Duration(milliseconds: 500));
        Get.to(() => SystemInfoScreen(widget.userSystems)); // Navigate on success
      } else {
        // Handle the case where "Hydroponix" network not found
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Device Not Found"),
            content: Text(
                "Couldn't find your Hydroponix device nearby. Please ensure it's powered on and broadcasting its Wi-Fi network."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // Handle errors during scanning or connection
      print("Error during Wi-Fi scan or connection: $error");
      // Display an error message to the user
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Device Not Found"),
          content: Text("An unexpected Error occurred. Please Try Again."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Searching for your System"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => isDeviceFound.value
                  ? Text("Hydroponix System Found. Connecting...")
                  : Text("Searching for your Hydroponix system...")),
              SizedBox(height: 20),
              CircularProgressIndicator(),
            ],
          ),
        ));
  }
}
