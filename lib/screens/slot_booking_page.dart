import 'package:flutter/material.dart';

class SlotBookingPage extends StatelessWidget {
  const SlotBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parking Slots")),
      body: const Center(
        child: Text("Slot Booking Screen 🚗", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
