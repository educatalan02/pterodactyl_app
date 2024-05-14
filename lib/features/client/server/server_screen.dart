import 'package:awesome_icons/awesome_icons.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pterodactyl_app/data/server_state.dart';
import 'package:pterodactyl_app/features/client/server/widgets/console.dart';
import 'package:pterodactyl_app/features/client/server/widgets/file_explorer/server_fileexplorer.dart';
import 'package:pterodactyl_app/features/client/server/widgets/more_actions.dart';

class ServerScreen extends StatefulWidget {
  const ServerScreen({super.key, required this.server});

  final ServerState server;

  @override
  ServerScreenState createState() => ServerScreenState();
}

class ServerScreenState extends State<ServerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.server.server.name),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Console(server: widget.server),
            ServerFileExplorer(server: widget.server),
            MoreActions(server: widget.server)
          ],
        ),
        bottomNavigationBar: CustomNavigationBar(
          currentIndex: _tabController.index,
          elevation: 20,
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          bubbleCurve: Curves.easeOutCirc,
          iconSize: 20,
          onTap: (index) {
            _tabController.animateTo(index);
          },
          items: [
            CustomNavigationBarItem(
              icon: const Icon(FontAwesomeIcons.terminal),
              title: Text("console".tr, style: const TextStyle(fontSize: 12)),
            ),
            CustomNavigationBarItem(
              icon: const Icon(FontAwesomeIcons.folder),
              title: Text("files".tr, style: const TextStyle(fontSize: 12)),
            ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.more),
              title:
                  Text("more_actions".tr, style: const TextStyle(fontSize: 12)),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabController.removeListener(() {
      setState(() {});
    });
    super.dispose();
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: _tabController,
      tabs: [
        Tab(
          icon: const Icon(FontAwesomeIcons.code, size: 20),
          text: _tabController.index == 0 ? "console".tr : null,
        ),
        Tab(
          icon: const Icon(FontAwesomeIcons.file, size: 20),
          text: _tabController.index == 1 ? "files".tr : null,
        ),
      ],
    );
  }
}
