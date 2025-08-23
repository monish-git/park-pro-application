import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Support")),
      body: const Center(
        child: Text("Support & Help Screen 📞", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
