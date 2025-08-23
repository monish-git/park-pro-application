import 'package:flutter/material.dart';
import 'slot_booking_page.dart';
import 'payments_page.dart';
import 'profile_page.dart';
import 'support_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ------------------ DRAWER / SIDEBAR ------------------
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlueAccent),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.lightBlueAccent),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Park-Pro User",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_parking),
              title: const Text("Slots"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SlotBookingPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text("Payments"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const PaymentsPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.support_agent),
              title: const Text("Support"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SupportPage()));
              },
            ),
          ],
        ),
      ),

      // ------------------ APPBAR WITH SEARCH ------------------
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent, // Top bar color
        title: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search parking slots...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),

      // ------------------ BODY ------------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Back 👋",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Find and book your parking slot easily with Park-Pro.",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Feature cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildFeatureCard(
                    Icons.local_parking, "Book Slot", Colors.lightBlue.shade100, context, const SlotBookingPage()),
                _buildFeatureCard(
                    Icons.payment, "Payments", Colors.orange.shade100, context, const PaymentsPage()),
                _buildFeatureCard(
                    Icons.person, "Profile", Colors.purple.shade100, context, const ProfilePage()),
                _buildFeatureCard(
                    Icons.support_agent, "Support", Colors.red.shade100, context, const SupportPage()),
              ],
            ),
            const SizedBox(height: 20),

            // Info Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "💡 Tip: Use the search bar above to quickly find available slots near you.",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ FEATURE CARD ------------------
  Widget _buildFeatureCard(
      IconData icon, String title, Color color, BuildContext context, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.black87),
              const SizedBox(height: 8),
              Text(title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
