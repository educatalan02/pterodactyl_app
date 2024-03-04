import 'package:pterodactyl_app/entities/model/server.dart';
import 'package:pterodactyl_app/presentation/screens/screens.dart';
import 'package:shimmer/shimmer.dart';
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
      
      actions: [
        
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/addserver');
          },
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
                  
                  child: ListTile(
                    leading: const Icon(Icons.cloud),
                    title: Text(snapshot.data![index].name),
                    subtitle: Text(snapshot.data![index].panelUrl),
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
            return Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[700]!,
            child: GridView.count(crossAxisCount:4,
          children: [ Card(
            color: Colors.grey[800],
            child: const ListTile(
              leading: Icon(Icons.cloud),
              title: Text('Server Name'),
              subtitle: Text('Panel URL'),
            ),
          )]
          ),
          );
          }

          return const CircularProgressIndicator();
        },
      ),
    ),
  );
}
}
