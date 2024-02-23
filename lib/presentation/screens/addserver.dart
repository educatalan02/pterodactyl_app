
import 'package:flutter/material.dart';

class AddServer extends StatelessWidget {
  const AddServer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Server'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // text fields for the server details

          children: [
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Socket URL',
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Panel URL',
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'API Key',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // save the server details
              },
              child: const Text('Save'),
            ),
          ],
          
        ),
      ),
    );
  }
}