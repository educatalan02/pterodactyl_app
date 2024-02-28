import 'package:flutter/material.dart';
import 'package:pterodactyl_app/models/server.dart';
import 'package:pterodactyl_app/presentation/screens/server/console.dart';
import 'package:pterodactyl_app/presentation/screens/server/server.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  Future<List<Server>> getServers() async {
    final Database db = await openDatabase(
      join(await getDatabasesPath(), 'servers.db'),
    );

    final List<Map<String, dynamic>> maps = await db.query('servers');

    return List.generate(maps.length, (i) {
      return Server(
        panelUrl: maps[i]['panel'],
        apiKey: maps[i]['apiKey'],
        serverId: maps[i]['serverId'],
        name: maps[i]['name'],
        socketUrl: maps[i]['socket'],
      );
    });
  }

  
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Pterodactyl App'),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24.0),
      backgroundColor: Colors.blue[800],
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/addserver');
          },
          color: Colors.white,
          highlightColor: Colors.grey[800],
          icon: const Icon(Icons.add),
        ),
      ],
    ),
    body: Center(
      child: FutureBuilder<List<Server>>(
        future: getServers(),
        builder: (BuildContext context, AsyncSnapshot<List<Server>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.grey[800],
                  child: ListTile(
                    leading: Icon(Icons.cloud, color: Colors.white),
                    title: Text(snapshot.data![index].name, style: TextStyle(color: Colors.white)),
                    subtitle: Text(snapshot.data![index].panelUrl, style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServerPanel(server: snapshot.data![index]),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("error ${snapshot.error}");
          }

          return const CircularProgressIndicator();
        },
      ),
    ),
  );
}
}
