import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/System.dart';
import '../models/SystemList.dart';
import '../models/SystemLogs.dart';
import 'package:Hydroponix/components/TimeInputFormatter.dart';
import '../services/mqtt_provider.dart';
import '../services/systems_controller.dart';

class SystemsScreen extends StatefulWidget {
  final SystemList? userSystemList;
  final Map<String, List<SystemLog>>? allSysLogs;
  final Map<String, List<SystemLog>>? latestReadings;
  final MQTTClientWrapper newClient;
  const SystemsScreen(this.userSystemList, this.allSysLogs, this.latestReadings, this.newClient, {Key? key})
      : super(key: key); // Constructor
  @override
  _SystemsScreenState createState() => _SystemsScreenState();
}

class _SystemsScreenState extends State<SystemsScreen> {
   final _systemsController = Get.put(SystemsController());
   final networkPassword = TextEditingController();
   final networkName = TextEditingController();
   final airPumpFreq = TextEditingController();
   final airPumpDur = TextEditingController();
   final waterPumpFreq = TextEditingController();
   final waterPumpDur = TextEditingController();
   final phMin = TextEditingController();
   final phMax = TextEditingController();
   final nutTempMin = TextEditingController();
   final nutTempMax = TextEditingController();
   final ambTempMin = TextEditingController();
   final ambTempMax = TextEditingController();
   @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ((widget.userSystemList?.systemList?.length ?? 0)),
            padding: EdgeInsets.all(16.0),
            itemBuilder: (context, index) {
              if (widget.userSystemList?.systemList != null && index < widget.userSystemList!.systemList!.length) {
                System? sys = widget.userSystemList!.systemList![index];
                final formKey = GlobalKey<FormState>();
                String AirFreq = _systemsController.MMSSFromSec(sys.airPumpInterval);
                String AirDur = _systemsController.MMSSFromSec(sys.airPumpDuration);
                String WaterFreq = _systemsController.MMSSFromSec(sys.waterPumpInterval);
                String WaterDur = _systemsController.MMSSFromSec(sys.waterPumpDuration);

                var changed = false;
                return SingleChildScrollView(
                    child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Card(
                      child: Form(
                        key: formKey,
                        onChanged: ()=>(changed=true),
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.memory),
                          title: Text((sys.Name as String)),
                          trailing: Text((sys.version as String)),
                        ),
                          ListTile(
                            title: Row(
                                children: [
                                  Icon(Icons.wifi),
                              Text(' Network')]
                            ),
                            subtitle:
                            Column(
                                children: [
                            Padding(
                             padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                             child: TextFormField(
                               controller: networkName..text = sys.ssid??'',
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8.0),
                                  isDense: true,
                                  labelText:'SSID',
                                  border: const OutlineInputBorder(gapPadding: 2.0),),
                                ),
                            ),
                             TextFormField(
                               controller: networkPassword..text = sys.password??'',
                               decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8.0),
                                  isDense: true,
                                    labelText:'Password',
                                  border: const OutlineInputBorder(),),
                               obscureText: true,
                              ),
                            ]),
                        ),
                        ListTile(
                          title: Row(
                              children: [
                                Icon(Icons.bubble_chart),
                                Text('Air Pump')]
                          ),
                          subtitle:Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Row(
                                    children: [
                                      Expanded( child:
                                      TextFormField(
                                        controller: airPumpFreq..text = AirFreq,
                                        decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(8.0),
                                        isDense: true,
                                        border: const OutlineInputBorder(),
                                        labelText:'Frequency'),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                      TimeInputFormatter()],
                                        // validator: (val){ return (_systemsController.validateTime(val)??
                                        //         'Invalid time format. Please enter a value in the format mm:ss.').toString();},
                                  )),
                                      SizedBox(
                                        width: 12,
                                      ),
                                Expanded(child:
                                TextFormField(
                                  controller: airPumpDur..text = AirDur,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(8.0),
                                      isDense: true,
                                      border: const OutlineInputBorder(),
                                      labelText:'Duration'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                    TimeInputFormatter()],
                                  // validator: (val){return (_systemsController.validateTime(val)??
                                  //       'Invalid time format. Please enter a value in the format mm:ss.').toString();},
                                ))
                                    ]))),
                              ListTile(
                            title: Row(
                            children: [Icon(Icons.cyclone),Text('Water Pump')]),
                            subtitle:
                              Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Row(
                                      children: [
                                        Expanded(
                                          child:
                                        TextFormField(
                                          controller: waterPumpFreq..text = WaterFreq,
                                          decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(8.0),
                                        isDense: true,
                                        border: const OutlineInputBorder(),
                                        labelText:'Frequency'),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(5),
                                      TimeInputFormatter()],
                                  )),
                      SizedBox(
                        width: 12,
                      ),
                          Expanded( child:
                                TextFormField(
                                  controller: waterPumpDur..text = WaterDur,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(8.0),
                                      isDense: true,
                                      border: const OutlineInputBorder(),
                                      labelText:'Duration'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    TimeInputFormatter(),
                                    LengthLimitingTextInputFormatter(5)],
                                )),
                              ]))),
                        ListTile(
                            title: Row(
                                children: [Icon(Icons.device_thermostat),Text('Nutrient Temperature')]),
                            subtitle:
                            Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Row(
                                    children: [
                                      Expanded(
                                          child:
                                          TextFormField(
                                            controller: nutTempMin..text = (sys.nutrientTempMin??0).toString(),
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.all(8.0),
                                                isDense: true,
                                                border: const OutlineInputBorder(),
                                                labelText:'Min'),
                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                              LengthLimitingTextInputFormatter(5)
                                              ],
                                          )),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Expanded( child:
                                      TextFormField(
                                        controller: nutTempMax..text = (sys.nutrientTempMax??0).toString(),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(8.0),
                                            isDense: true,
                                            border: const OutlineInputBorder(),
                                            labelText:'Max'),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                          LengthLimitingTextInputFormatter(5)],
                                      )),
                                    ]))),
                        ListTile(
                            title: Row(
                                children: [Icon(Icons.water_drop),Text('pH')]),
                            subtitle:
                            Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Row(
                                    children: [
                                      Expanded(
                                          child:
                                          TextFormField(
                                            controller: phMin..text = (sys.phMin??0).toString(),
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.all(8.0),
                                                isDense: true,
                                                border: const OutlineInputBorder(),
                                                labelText:'Min'),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                              LengthLimitingTextInputFormatter(4)],
                                          )),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Expanded( child:
                                      TextFormField(
                                        controller: phMax..text = (sys.phMax??0).toString(),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(8.0),
                                            isDense: true,
                                            border: const OutlineInputBorder(),
                                            labelText:'Max'),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                          LengthLimitingTextInputFormatter(4)],
                                      )),
                                    ]))),
                        ListTile(
                            title: Row(
                                children: [Icon(Icons.thermostat),Text('Ambient Temperature')]),
                            subtitle:
                            Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Row(
                                    children: [
                                      Expanded(
                                          child:
                                          TextFormField(
                                            controller: ambTempMin..text = (sys.ambientTempMin??0).toString(),
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.all(8.0),
                                                isDense: true,
                                                border: const OutlineInputBorder(),
                                                labelText:'Min'),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                              LengthLimitingTextInputFormatter(5)],
                                          )),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Expanded( child:
                                      TextFormField(
                                        controller: ambTempMax..text = (sys.ambientTempMax??0).toString(),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(8.0),
                                            isDense: true,
                                            border: const OutlineInputBorder(),
                                            labelText:'Max'),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                          LengthLimitingTextInputFormatter(5)],
                                      )),
                                    ]))),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: const Text('SAVE CONFIG'),
                                onPressed: () {
                                  if (changed == true) {
                                    _systemsController.submitForm(widget.userSystemList!,
                                        sys,
                                      networkName.text,
                                      networkPassword.text,
                                      airPumpFreq.text,
                                      airPumpDur.text,
                                      waterPumpFreq.text,
                                      waterPumpDur.text,
                                      nutTempMin.text,
                                      nutTempMax.text,
                                      phMin.text,
                                      phMax.text,
                                      ambTempMin.text,
                                      ambTempMax.text
                                    );
                                    String json = jsonEncode(sys.toFirestore());
                                    final user = FirebaseAuth.instance.currentUser;
                                    String topic = user!.uid + "/" + sys.systemId!;
                                    widget.newClient.publishMessage(json, topic);
                                  }
                                  else {

                                  }
                                }),
                              const SizedBox(width: 8),
                              TextButton(
                                child: const Text('VIEW DATA'),
                                onPressed: () {/* ... */},
                              ),
                              const SizedBox(width: 8),
                            ]),
                      ]),
                    ))));
              } else {
              return Container(
                  padding: EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.40,
                  child: Card(
                      child: ListTile(
                        leading: Icon(Icons.warning),
                        title: Text("No Systems Added!"),
                        subtitle: Text("Add Systems & View Configurations Here"),
                      )
                  )
              );
              }
            }
            ));
  }

}