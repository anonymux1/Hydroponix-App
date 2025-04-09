import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../../models/SystemList.dart';

class SystemModulesMappingController extends GetxController {

   Future<void> controlSwitch(int? switchIndex, bool state) async {
    final url = Uri.http('192.168.1.1', '/control',
        {'switch': '$switchIndex', 'state': '$state'});
    await http.post(url);
  }

  Future<void> mapHobbyModules(SystemList? userSystems) async {
    await controlSwitch(0, true);
    final moduleTypeAlert = await showDialog<String>(
      context: Get.context!,
      builder: (context) =>
          AlertDialog(
            title: const Text(
                'Identifying which Pump is plugged into which switch'),
            content: const Text('Which Pump turned ON?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Water Pump'),
                child: const Text('Water Pump'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'Air Pump'),
                child: const Text('Air Pump'),
              ),
            ],
          ),
    );
    var length = userSystems
        ?.getSystemList()
        ?.length;
    if (moduleTypeAlert != null ||
        await Future.delayed(const Duration(seconds: 5))) {
      await controlSwitch(0, false);
    }
    if (moduleTypeAlert == 'Air Pump') {
      userSystems?.getSystemList()?[length!].modules =
      {'Air Pump': 0, 'Water Pump': 1};
    } else if (moduleTypeAlert == 'Water Pump') {
      userSystems?.getSystemList()?[length!].modules =
      {'Water Pump': 0, 'Air Pump': 1};
    }
  }

  Future<void> mapProModules(SystemList? userSystems, List<String> modulesList,
      String? selectedItem, Function updateUI) async {
    var length = userSystems
        ?.getSystemList()
        ?.length;
    final switches = userSystems?.getSystemList()?[length!].switches ?? 0;
    for (int switchIndex = 0; switchIndex < switches; switchIndex++) {
      await controlSwitch(switchIndex, true);
      bool addAnotherDevice = true;
      while (addAnotherDevice) {
        final moduleTypeAlert = await showDialog<String>(
          context: Get.context!,
          builder: (context) =>
              AlertDialog(
                title: const Text('Select Device that turned ON'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String>(
                      value: selectedItem,
                      items: modulesList.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          selectedItem = newValue;
                        }
                      },
                    ),
                    if (userSystems?.getSystemList()?[length!].modules != null)
                      ...userSystems!.getSystemList()![length!].modules!.entries
                          .map((entry) {
                        return Text('${entry.key}: Switch ${entry.value}');
                      }).toList(),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, selectedItem),
                    child: const Text('Add Another Device'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, null),
                    child: const Text('Done'),
                  ),
                ],
              ),
        );
        if (moduleTypeAlert != null) {
          await controlSwitch(switchIndex, false);
          userSystems?.getSystemList()?[length!].modules ??= {};
          userSystems?.getSystemList()?[length!].modules![moduleTypeAlert] =
              switchIndex;
          updateUI();
        }
        else
          addAnotherDevice = false;
      }
      await controlSwitch(switchIndex, false);
    }
  }
}