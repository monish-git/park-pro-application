import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/slot_booking_page.dart';
import 'screens/payments_page.dart';
import 'screens/profile_page.dart';

void main() {
  runApp(const ParkProApp());
}

class ParkProApp extends StatefulWidget {
  const ParkProApp({super.key});

  @override
  State<ParkProApp> createState() => _ParkProAppState();
}

class _ParkProAppState extends State<ParkProApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    SlotBookingPage(),
    PaymentsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Park Pro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(icon: Icon(Icons.local_parking), label: "Slots"),
            NavigationDestination(icon: Icon(Icons.payment), label: "Payments"),
            NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
