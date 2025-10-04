import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoggedIn = false;
  String userName = "";
  String userEmail = "";

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2937),
        elevation: 0,
        title: Text(
          isLoggedIn ? "Profile" : "Login",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: isLoggedIn ? _buildProfileView() : _buildLoginView(),
    );
  }

  // ---------------- Profile Page ----------------
  Widget _buildProfileView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/profile.png"),
                ),
                const SizedBox(height: 12),
                Text(userName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                Text(userEmail,
                    style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 10),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Account Options
          _buildListTile(Icons.history, "My Bookings"),
          _buildListTile(Icons.payment, "Payment Methods"),
          _buildListTile(Icons.account_balance_wallet, "Wallet Balance"),
          _buildListTile(Icons.notifications, "Notifications"),
          _buildListTile(Icons.settings, "Settings"),
          _buildListTile(Icons.help, "Help & Support"),

          const SizedBox(height: 20),

          // Logout
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              setState(() {
                isLoggedIn = false;
                userName = "";
                userEmail = "";
              });
            },
            child: const Text("Logout",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  // ---------------- Login Page ----------------
  Widget _buildLoginView() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Login to Park-Pro+",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          TextField(
            controller: emailController,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration("Email"),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: passwordController,
            obscureText: true,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration("Password"),
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (emailController.text.isNotEmpty &&
                  passwordController.text.isNotEmpty) {
                setState(() {
                  isLoggedIn = true;
                  userEmail = emailController.text;
                  userName = "User"; // Default until signup provides name
                });
              }
            },
            child: const Text("Login",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),

          TextButton(
            onPressed: () {
              _showSignupDialog(context);
            },
            child: const Text("Don’t have an account? Sign Up",
                style: TextStyle(color: Colors.blueAccent)),
          )
        ],
      ),
    );
  }

  // ---------------- Signup Pop-Up ----------------
  void _showSignupDialog(BuildContext context) {
    final TextEditingController signupEmail = TextEditingController();
    final TextEditingController signupName = TextEditingController();
    final TextEditingController signupPassword = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1F2937),
          title: const Text("Sign Up", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: signupName,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Name"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: signupEmail,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Email"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: signupPassword,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Password"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6)),
              onPressed: () {
                if (signupEmail.text.isNotEmpty &&
                    signupName.text.isNotEmpty &&
                    signupPassword.text.isNotEmpty) {
                  setState(() {
                    isLoggedIn = true;
                    userEmail = signupEmail.text;
                    userName = signupName.text;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Sign Up",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // ---------------- Widgets ----------------
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF1F2937),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none),
    );
  }

  Widget _buildListTile(IconData icon, String title) {
    return Card(
      color: const Color(0xFF1F2937),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF3B82F6)),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: () {},
      ),
    );
  }
}
