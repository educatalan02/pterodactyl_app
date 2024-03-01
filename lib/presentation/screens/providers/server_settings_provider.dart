
import 'package:flutter/material.dart';
import 'package:pterodactyl_app/entities/model/server.dart';

class ServerSettingsProvider extends ChangeNotifier{

  Server? _server;


 
  Server? get server => _server;


  void setServer (Server server){
    _server = server;
    notifyListeners();
  }

  void updateServer(Server server){
    _server = server;
    notifyListeners();
  }

}