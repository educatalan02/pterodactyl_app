import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:pterodactyl_app/entities/model/server.dart';
import 'package:pterodactyl_app/presentation/screens/screens.dart';
import 'package:sqflite/sqflite.dart';

class ServerSettings extends StatelessWidget {
  const ServerSettings({super.key, required this.server});
  final Server server;

  


  Future<void> updateServer(Server server) async {

    final database = openDatabase(
      join(await getDatabasesPath(), 'servers.db'),
    );

    await database.then((db) async {
      await db.update(
        'servers',
        server.toMap(),
        where: 'name = ?',
        whereArgs: [server.name],
      );
    });
  }

  

  @override
  Widget build(BuildContext context) {
    final TextEditingController tagController = TextEditingController(text: server.optionalTag);
  final TextEditingController serverIdController = TextEditingController(text: server.serverId);
  final TextEditingController apiKeyController = TextEditingController(text: server.apiKey);
  final TextEditingController panelController = TextEditingController(text: server.panelUrl);
    return Scaffold(
      appBar: AppBar(
        title: Text(server.name),
        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Optional Tag',
              ),
              controller: tagController,
            ),
            const SizedBox(height: 10),

            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Server ID',
              ),
              controller: serverIdController,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'API Key',
              ),
              controller: apiKeyController,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Panel URL',
                
              ),
              controller: panelController,
            ),
            ElevatedButton(
              onPressed: () async {
                server.optionalTag = tagController.text;
                server.serverId = serverIdController.text;
                server.apiKey = apiKeyController.text;
                server.panelUrl = panelController.text;

                await updateServer(server);

                
                
                Future.delayed(Duration.zero, (){
Provider.of<ServerSettingsProvider>(context, listen: false).updateServer(server);
                });

                Future.delayed(const Duration(milliseconds: 500), () async {
                  await Navigator.maybePop(context);
                });



               
              },
              child: const Text('Save'),
            ),
          ]
          
        ),
      ),
    );
  }
}