import 'package:flutter/material.dart';

class DeactivateFastagPage extends StatelessWidget {
  const DeactivateFastagPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Deactivate FASTag"), backgroundColor: Colors.blueAccent),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Are you sure you want to deactivate your FASTag?",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("FASTag Deactivated")),
                );
                Navigator.pop(context);
              },
              child: const Text("Deactivate"),
            )
          ],
        ),
      ),
    );
  }
}
