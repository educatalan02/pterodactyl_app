

import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pterodactyl App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // necesito un boton para añadir un servidor nuevo
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addserver');
              },
              child: const Text('Add Server'),
            ),

            // necesito una lista de botones para los servidores guardados

            
          ]
          
        ),
      ),
    );
  }
}