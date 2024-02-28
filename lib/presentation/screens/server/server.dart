import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:pterodactyl_app/models/server.dart';
import 'package:pterodactyl_app/models/usage_data.dart';
import 'package:http/http.dart' as http;
import 'package:pterodactyl_app/presentation/screens/server/console.dart';

// ignore: must_be_immutable
class ServerPanel extends StatefulWidget {
  ServerPanel({super.key, required this.server});

  late Server server;

  @override
  State<ServerPanel> createState() => _ServerPanelState();
}

class _ServerPanelState extends State<ServerPanel> {
   
   

   

late bool serverIsSuspended = false;

  late final bool animate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(widget.server.name),
    backgroundColor: Colors.blue[800],
    
    actions: [
      if(serverIsSuspended)
      IconButton(
        icon: const Icon(Icons.power_settings_new_outlined, color: Colors.green),
        onPressed: () async {

          final response = await http.post(
            Uri.parse(
                '${widget.server.panelUrl}/api/client/servers/${widget.server.serverId}/power'),
            headers: <String, String>{
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${widget.server.apiKey}',
            },
            body: jsonEncode(<String, String>{
              'signal': 'start',
            }),
          );

          if(response.statusCode == 204){
            setState(() {
              serverIsSuspended = false;
            });
          }
          //Navigator.push(context, MaterialPageRoute(builder: (context) => Console(server: widget.server)));
        
        }
      ),

      if(!serverIsSuspended)
      IconButton(
        icon: const Icon(Icons.power_settings_new, color: Colors.red),
        onPressed: () async {

          final response = await http.post(
            Uri.parse(
                '${widget.server.panelUrl}/api/client/servers/${widget.server.serverId}/power'),
            headers: <String, String>{
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${widget.server.apiKey}',
            },
            body: jsonEncode(<String, String>{
              'signal': 'stop',
            }),


          );

          if(response.statusCode == 204){


            setState(() {
              serverIsSuspended = true;
            });


            
          }
          //Navigator.push(context, MaterialPageRoute(builder: (context) => Console(server: widget.server)));
        },
      ),

      
    ],

    ),
    
    
    
    body: StreamBuilder<UsageData>(
      stream: fetchServerResourcesStream(),
      builder: (BuildContext context, AsyncSnapshot<UsageData> snapshot) {
        if (snapshot.hasData && !serverIsSuspended) {
          return GridView.count(crossAxisCount:4,
          children: [
            Card(
              color: Colors.grey[850],
              child: Padding(padding:  const EdgeInsets.all(8.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [const Icon(Icons.memory),
              const Text("CPU", style: TextStyle(fontWeight: FontWeight.bold)),
              Text('${snapshot.data!.cpu.toStringAsFixed(2)}%'),
              ],
              ),
            ),
            ),
            Card(
              color: Colors.grey[850],
              child: Padding(padding:  const EdgeInsets.all(8.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [const Icon(Icons.storage),
              const Text("RAM", style: TextStyle(fontWeight: FontWeight.bold)),
              Text('${(snapshot.data!.ram / 1073741824).toStringAsFixed(2)} GB'),
              ],
              ),
            ),
            ),
            Card(
              color: Colors.grey[850],
              child: Padding(padding:  const EdgeInsets.all(8.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [const Icon(Icons.sd_storage),
              const Text("Disk", style: TextStyle(fontWeight: FontWeight.bold)),
              Text('${(snapshot.data!.disk / 1073741824).toStringAsFixed(2)} GB'),
              ],
              ),
            ),
            ),

            Card(
              color: Colors.grey[850],
              child: Padding(padding:  const EdgeInsets.all(8.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [const Icon(Icons.timer),
              const Text("Uptime", style: TextStyle(fontWeight: FontWeight.bold)),

              // uptime is in miliseconds, so we divide by 1000 to get seconds, then by 60 to get minutes, then by 60 to get hours, then by 24 to get days
              Text('${getUptime(snapshot.data!.uptime)}'),
              ],
              ),
            ),
            ),
          ],
          
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(child: CircularProgressIndicator(backgroundColor: Colors.blue[800],)
          );
        }
      },
    ),

    bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(


          icon: Icon(Icons.laptop_chromebook),
          label: 'Console',
          

          


          
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      onTap: (value) {
        if(value == 0){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Console(server: widget.server)));
        }
      
      },
      selectedItemColor: Colors.blue[800],
      backgroundColor: Colors.grey[850],
    ),
    );

  }

  String getUptime(int uptime){
    Duration uptimeDuration = Duration(milliseconds: uptime);
    if (uptimeDuration.inDays == 0) {
      return '${uptimeDuration.inHours.remainder(24)}h ${uptimeDuration.inMinutes.remainder(60)}m';
    }
    if(uptimeDuration.inHours == 0){
      return '${uptimeDuration.inMinutes.remainder(60)}m';
    }

    return '${uptimeDuration.inDays}d ${uptimeDuration.inHours.remainder(24)}h ${uptimeDuration.inMinutes.remainder(60)}m ';
  }

  @override
  void initState() {
    super.initState();
    fetchServerResources();
    
  }

  Future<UsageData> fetchServerResources() async {

double cpuUsage = 0.0;
    int memoryUsage = 0;
    int diskUsage = 0;
    int uptime = 0;
    String currentState = '';
    bool isSuspended = false;
    


        final response = await http.get(
      Uri.parse(
          '${widget.server.panelUrl}/api/client/servers/${widget.server.serverId}/resources'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.server.apiKey}',
      },
    );

    switch (response.statusCode) {
      case 200:
        // Si el servidor devuelve una respuesta OK, parsea el JSON.
        //print(jsonDecode(response.body));
        final data = jsonDecode(response.body);
        // {"object":"stats","attributes":{"current_state":"running","is_suspended":false,"resources":{"memory_bytes":1023197184,"cpu_absolute":62.413,"disk_bytes":3249573374,"network_rx_bytes":17457522,"network_tx_bytes":206805255,"uptime":68212135}}}




        cpuUsage = data["attributes"]["resources"]["cpu_absolute"];

        memoryUsage = data["attributes"]["resources"]["memory_bytes"];

        diskUsage = data["attributes"]["resources"]["disk_bytes"];

        uptime = data["attributes"]["resources"]["uptime"];
        print(data["attributes"]["resources"]);

        currentState = data["attributes"]["current_state"];

        isSuspended = data["attributes"]["is_suspended"];

        return UsageData(
          uptime: uptime,
          cpu: cpuUsage,
          ram: memoryUsage,
          disk: diskUsage,
          isSuspended: isSuspended,
          currentState: currentState,
        );

      case 401:
        throw Exception('Unauthorized request. Check your API key.');
      case 404:
        throw Exception('Server not found. Check your server ID.');
      default:
        throw Exception(
            'Failed to load server details. Status code: ${response.statusCode}');
    }




  }

  Stream<UsageData> fetchServerResourcesStream() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield await fetchServerResources();
    }
  }

  

  @override
  void dispose() {
    super.dispose();
  }
}
