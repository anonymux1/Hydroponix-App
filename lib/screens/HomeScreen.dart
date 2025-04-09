import 'dart:developer';

// import 'package:Hydroponix/models/System.dart';
import 'package:Hydroponix/models/SystemList.dart';
import 'package:Hydroponix/screens/addSystem/SystemDiscover.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Hydroponix/services/home_controller.dart';
// import 'package:skeletonizer/skeletonizer.dart';
import '../models/SystemLogs.dart';

class HomeScreen extends StatefulWidget {
  final SystemList? userSystemList;
  final Map<String, List<SystemLog>>? allSysLogs;
  final Map<String, List<SystemLog>>? latestReadings;
   HomeScreen(this.userSystemList, this.allSysLogs, this.latestReadings, {Key? key})
      : super(key: key); // Constructor


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());
  String sensorString = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: //Obx((){
          // return (homeController.isComputing.value?
           // Column(
           //    children: [
           //      Expanded(child: Center(child: CircularProgressIndicator())),
           //    ]) :
          (
          SingleChildScrollView(
        // Or Column, ListView as needed
          child: Column(children: [
            ElevatedButton(
              onPressed: () {
                Get.to(() => SystemDiscoverScreen(widget.userSystemList));
              },
              child: const Text('ADD NEW SYSTEM'),
            ),
            Container(
                padding: EdgeInsets.symmetric(),
                height: MediaQuery.of(context).size.height * 0.4,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: ((widget.userSystemList?.systemList?.length ?? 0)),
                    padding: EdgeInsets.all(16.0),
                    itemBuilder: (context, index) {
                      if (widget.userSystemList?.systemList != null && index < widget.userSystemList!.systemList!.length) {
                        final sys = widget.userSystemList!.systemList![index]; // Access system at index
                        log("HomeScreen Sys: ${sys.toString()}");
                        log("HomeScreen All latestReadings: ${widget.latestReadings.toString()} ");
                        log("HomeScreen latestReadings: ${widget.latestReadings?[sys.systemId].toString()}");
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.album),
                                  title: Text((sys.Name as String)),
                                  trailing: Text((sys.version as String)),
                                ),
                                ListTile(
                                  title: Text('Current Status'),
                                  subtitle: Text(homeController.makeStatusString(widget.latestReadings?[sys.systemId])),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    TextButton(
                                      child: const Text('EDIT CONFIG'),
                                      onPressed: () {/* ... */},
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      child: const Text('VIEW DATA'),
                                      onPressed: () {/* ... */},
                                    ),const SizedBox(width: 8),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink(); // Return an empty widget if no system at index
                      }
                    }
                    )
            )
          ]
          )
          )));
    // }));
  }
}
