import 'package:get/get.dart';
import 'package:pterodactyl_app/entities/model/server.dart';
import 'package:pterodactyl_app/presentation/screens/main/settings_screen.dart';
import 'package:pterodactyl_app/presentation/screens/screens.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';




class ServerController extends GetxController {
  var servers = <Server>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchServers();
  }

  void fetchServers() async {
    final Database db = await openDatabase(
      join(await getDatabasesPath(), 'servers.db'),
    );

    final List<Map<String, dynamic>> maps = await db.query('servers');

    servers.value = List.generate(maps.length, (i) {
      return Server(
        
        panelUrl: maps[i]['panel'],
        apiKey: maps[i]['apiKey'],
        serverId: maps[i]['serverId'],
        name: maps[i]['name'],
        socketUrl: maps[i]['socket'],
      );
    });
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final ServerController serverController = Get.put(ServerController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pterodactyl App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.to(const AppSettings());
            },
          ),
        ],
      ),
      body: Center(
        child: Obx(
          () => ListView.builder(
            itemCount: serverController.servers.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.cloud),
                  title: Text(serverController.servers[index].name),
                  subtitle: Text(serverController.servers[index].panelUrl),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ServerPanel(server: serverController.servers[index]),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Get.to(AddServer());
          serverController.fetchServers(); // Actualiza la lista de servidores después de añadir un nuevo servidor
        },
      ),
    );
  }
}
