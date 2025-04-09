import 'package:Hydroponix/screens/addSystem/SystemModulesMapping.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/SystemList.dart';
import '../../services/networkcredentials_controller.dart';

class NetworkCredentialsScreen extends StatefulWidget {
  final SystemList? userSystems;
  final bool use2G;
  const NetworkCredentialsScreen(this.userSystems, this.use2G, {Key? key}) : super(key: key);

  @override
  _NetworkCredentialsScreenState createState() => _NetworkCredentialsScreenState();
}

class _NetworkCredentialsScreenState extends State<NetworkCredentialsScreen> {
  final NetworkCredentialsController networkCredentialsController = Get.find();
  String? selectedNetwork = 'Hydroponix';
  String? networkPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter WiFi Credentials")),
      body: Column(
        children: [
          if(widget.use2G)
            Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'SSID', hintText: 'Hydroponix'),
                  onChanged: (value) {
                    selectedNetwork = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onChanged: (value) {
                    networkPassword = value;
                  },
                ),
              ],
            )
          else
          FutureBuilder<List<DropdownMenuItem<String>>?>(
            future: networkCredentialsController.getNetworks(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error fetching networks');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No networks found by Hydroponix System');
              } else {
                return Column(
                  children: [
                    DropdownButtonFormField<String>(
                      items: snapshot.data,
                      onChanged: (value) {
                        selectedNetwork = value;
                      },
                      decoration: InputDecoration(labelText: 'Select Network'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Network Password'),
                      obscureText: true,
                      onChanged: (value) {
                        networkPassword = value;
                      },
                    ),
                  ],
                );
              }
            },
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedNetwork != null && networkPassword != null) {
                await networkCredentialsController.saveNetworkCredentials(widget.userSystems, selectedNetwork!, networkPassword!, widget.use2G);
                setState(() {});
              }
              else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill in all fields')),
                );
              }
            },
            child: Text('Submit'),
          ),
          ElevatedButton(
              onPressed: (){
                Get.to(() => SystemModulesMappingScreen(widget.userSystems));
                },
              child: Text('NEXT'),
          )
        ],
      ),
    );
  }
}