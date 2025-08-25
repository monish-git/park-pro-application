import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // User profile data
  Map<String, dynamic> _userProfile = {
    'name': 'Monish',
    'email': 'monish@email.com',
    'phone': '+91 1234566666',
    'profileImage': null, // null for no image, use placeholder
    'memberSince': '2024-01-15',
    'totalBookings': 12,
    'favoriteSpots': 3,
    'vehicles': [
      {'number': 'TS09AB1234', 'type': 'Car', 'isDefault': true},
      {'number': 'TS08CD5678', 'type': 'Bike', 'isDefault': false},
    ],
  };

  // Settings states
  bool _notificationsEnabled = true;
  bool _emailUpdates = true;
  bool _smsAlerts = false;
  bool _darkMode = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current data
    _nameController.text = _userProfile['name'];
    _emailController.text = _userProfile['email'];
    _phoneController.text = _userProfile['phone'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _editProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          _saveProfileChanges();
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveProfileChanges() {
    setState(() {
      _userProfile['name'] = _nameController.text;
      _userProfile['email'] = _emailController.text;
      _userProfile['phone'] = _phoneController.text;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _manageVehicles() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Manage Vehicles',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ..._userProfile['vehicles'].map<Widget>((vehicle) {
                return ListTile(
                  leading: Icon(
                    vehicle['type'] == 'Car' ? Icons.directions_car : Icons.two_wheeler,
                    color: Colors.blue.shade800,
                  ),
                  title: Text(vehicle['number']),
                  subtitle: Text(vehicle['type']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (vehicle['isDefault'])
                        const Chip(
                          label: Text('Default'),
                          backgroundColor: Colors.green,
                          labelStyle: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeVehicle(vehicle),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _addNewVehicle,
                icon: const Icon(Icons.add),
                label: const Text('Add New Vehicle'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _addNewVehicle() {
    // Implement vehicle addition logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add vehicle functionality')),
    );
  }

  void _removeVehicle(Map<String, dynamic> vehicle) {
    setState(() {
      _userProfile['vehicles'].remove(vehicle);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${vehicle['number']} removed')),
    );
  }

  void _showHelpSupport() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Help & Support',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildSupportOption(
                icon: Icons.help_center,
                title: 'FAQs & Help Center',
                onTap: () {},
              ),
              _buildSupportOption(
                icon: Icons.support_agent,
                title: 'Contact Support',
                onTap: () {},
              ),
              _buildSupportOption(
                icon: Icons.description,
                title: 'Terms & Conditions',
                onTap: () {},
              ),
              _buildSupportOption(
                icon: Icons.security,
                title: 'Privacy Policy',
                onTap: () {},
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSupportOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade800),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(),
            const SizedBox(height: 24),

            // Statistics Cards
            _buildStatisticsRow(),
            const SizedBox(height: 24),

            // Settings Section
            _buildSettingsSection(),
            const SizedBox(height: 24),

            // Support Section
            _buildSupportSection(),
            const SizedBox(height: 24),

            // Logout Button
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue.shade100,
            backgroundImage: _userProfile['profileImage'] != null
                ? NetworkImage(_userProfile['profileImage'])
                : null,
            child: _userProfile['profileImage'] == null
                ? const Icon(
              Icons.person,
              size: 40,
              color: Colors.lightBlueAccent,
            )
                : null,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userProfile['name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _userProfile['email'],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _userProfile['phone'],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Member since ${_userProfile['memberSince']}',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.lightBlueAccent),
            onPressed: _editProfile,
            tooltip: 'Edit Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            value: _userProfile['totalBookings'].toString(),
            label: 'Total Bookings',
            icon: Icons.book_online,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            value: _userProfile['favoriteSpots'].toString(),
            label: 'Favorite Spots',
            icon: Icons.favorite,
            color: Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            value: _userProfile['vehicles'].length.toString(),
            label: 'Vehicles',
            icon: Icons.directions_car,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsOption(
            icon: Icons.notifications,
            title: 'Push Notifications',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) => setState(() => _notificationsEnabled = value),
            ),
          ),
          _buildSettingsOption(
            icon: Icons.email,
            title: 'Email Updates',
            trailing: Switch(
              value: _emailUpdates,
              onChanged: (value) => setState(() => _emailUpdates = value),
            ),
          ),
          _buildSettingsOption(
            icon: Icons.sms,
            title: 'SMS Alerts',
            trailing: Switch(
              value: _smsAlerts,
              onChanged: (value) => setState(() => _smsAlerts = value),
            ),
          ),
          _buildSettingsOption(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            trailing: Switch(
              value: _darkMode,
              onChanged: (value) => setState(() => _darkMode = value),
            ),
          ),
          _buildSettingsOption(
            icon: Icons.directions_car,
            title: 'Manage Vehicles',
            trailing: const Icon(Icons.chevron_right),
            onTap: _manageVehicles,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Support',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSupportOption(
            icon: Icons.help_center,
            title: 'Help & Support',
            onTap: _showHelpSupport,
          ),
          _buildSupportOption(
            icon: Icons.star,
            title: 'Rate Our App',
            onTap: () {},
          ),
          _buildSupportOption(
            icon: Icons.share,
            title: 'Share App',
            onTap: () {},
          ),
          _buildSupportOption(
            icon: Icons.info,
            title: 'About App',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.lightBlueAccent),
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _logout,
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text(
          'Logout',
          style: TextStyle(color: Colors.red),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}