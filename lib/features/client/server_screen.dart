import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:pterodactyl_app/data/server_state.dart';
import 'package:pterodactyl_app/features/client/widgets/console.dart';
import 'package:pterodactyl_app/features/client/widgets/file_explorer/server_fileexplorer.dart';

class ServerScreen extends StatelessWidget {
  ServerScreen({super.key, required this.server});

  PersistentTabController controller = PersistentTabController(initialIndex: 0);

  final ServerState server;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(server.server.name),
      ),
      body: PersistentTabView(
        context,
        controller: controller,
        screens: [
          Console(server: server),
          ServerFileExplorer(server: server),
          //ServerConsole(server: server),
          //ServerSettings(server: server),
        ],
        items: [
          PersistentBottomNavBarItem(
            icon: const Icon(Icons.code),
            title: ("console".tr),
            activeColorPrimary: Colors.blue,
            inactiveColorPrimary: Colors.grey,
          ),
          PersistentBottomNavBarItem(
            icon: const Icon(FontAwesomeIcons.file),
            title: ("files".tr),
            activeColorPrimary: Colors.blue,
            inactiveColorPrimary: Colors.grey,
          ),

          // PersistentBottomNavBarItem(
          //   icon: Icon(Icons.settings),
          //   title: ("Settings"),
          //   activeColorPrimary: Colors.blue,
          //   inactiveColorPrimary: Colors.grey,
          // ),
        ],
      ),
    );
  }
}
