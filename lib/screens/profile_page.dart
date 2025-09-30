import 'package:flutter/material.dart';

// ✅ Adjust these imports if your paths differ
import 'helpsupport_page.dart';

/// PROFILE PAGE — UPDATED THEME (professional color palette)
/// Primary: 0xFF1976D2 (deep blue)
/// Accent: 0xFFFFA000 (amber)
/// Background: 0xFFF4F6FA (soft grey)
const Color primaryColor = Color(0xFF1976D2);
const Color accentColor = Color(0xFFFFA000);
const Color backgroundColor = Color(0xFFF4F6FA);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ─────────────────────────────────────────────────────────────────────────────
  // MOCK USER DATA (replace with your backend data when ready)
  // ─────────────────────────────────────────────────────────────────────────────
  Map<String, dynamic> _userProfile = {
    'name': 'Monish',
    'email': 'monish@gmail.com',
    'phone': '+91 1234566666',
    'profileImage': null, // null for placeholder avatar
    'memberSince': '2024-01-15',
    'totalBookings': 12,
    'favoriteSpots': 3,
    'loyaltyPoints': 420,
    'kycStatus': 'Verified',
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
  bool _twoFactorAuth = false;
  String _language = 'English';

  // Linked accounts
  bool _linkedGoogle = true;
  bool _linkedApple = false;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Add vehicle controllers
  final TextEditingController _vehNumberController = TextEditingController();
  String _vehType = 'Car';

  // Mock recent logins
  final List<Map<String, String>> _recentLogins = [
    {'device': 'Pixel 7', 'location': 'Hyderabad, IN', 'time': 'Today • 10:14 AM'},
    {'device': 'iPad', 'location': 'Hyderabad, IN', 'time': 'Yesterday • 8:02 PM'},
    {'device': 'Windows PC', 'location': 'Bengaluru, IN', 'time': '2 days ago • 6:45 PM'},
  ];

  @override
  void initState() {
    super.initState();
    _nameController.text = _userProfile['name'];
    _emailController.text = _userProfile['email'];
    _phoneController.text = _userProfile['phone'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _vehNumberController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // ACTIONS
  // ─────────────────────────────────────────────────────────────────────────────

  void _openHelpSupport() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HelpSupportPage()),
    );
  }

  void _editProfileSheet() {
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
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 8,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Edit Profile',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor)),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: const Icon(Icons.email),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor)),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: const Icon(Icons.phone),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: primaryColor.withOpacity(0.6)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          _saveProfileChanges();
                          Navigator.pop(context);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveProfileChanges() {
    setState(() {
      _userProfile['name'] = _nameController.text.trim();
      _userProfile['email'] = _emailController.text.trim();
      _userProfile['phone'] = _phoneController.text.trim();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _manageVehiclesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 8,
          ),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Manage Vehicles',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ..._userProfile['vehicles'].map<Widget>((vehicle) {
                      final bool isDefault = vehicle['isDefault'] == true;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(
                            vehicle['type'] == 'Car'
                                ? Icons.directions_car
                                : Icons.two_wheeler,
                            color: primaryColor,
                          ),
                          title: Text(vehicle['number']),
                          subtitle: Text(vehicle['type']),
                          trailing: Wrap(
                            spacing: 6,
                            children: [
                              if (isDefault)
                                Chip(
                                  label: const Text('Default'),
                                  backgroundColor: Colors.green.shade600,
                                  labelStyle: const TextStyle(color: Colors.white, fontSize: 10),
                                  padding: EdgeInsets.zero,
                                ),
                              IconButton(
                                tooltip: 'Set as default',
                                onPressed: () {
                                  _setDefaultVehicle(vehicle);
                                  setSheetState(() {});
                                },
                                icon: Icon(Icons.push_pin_outlined, color: primaryColor),
                              ),
                              IconButton(
                                tooltip: 'Remove',
                                onPressed: () {
                                  _removeVehicle(vehicle);
                                  setSheetState(() {});
                                },
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text('Add New Vehicle',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _vehNumberController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        labelText: 'Vehicle Number (e.g., TS09AB1234)',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.confirmation_num_outlined),
                        focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Type:'),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Car'),
                          selected: _vehType == 'Car',
                          selectedColor: primaryColor.withOpacity(0.12),
                          onSelected: (v) {
                            setSheetState(() => _vehType = 'Car');
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Bike'),
                          selected: _vehType == 'Bike',
                          selectedColor: primaryColor.withOpacity(0.12),
                          onSelected: (v) {
                            setSheetState(() => _vehType = 'Bike');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add Vehicle'),
                        style: FilledButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _addNewVehicle();
                          _vehNumberController.clear();
                          setSheetState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _addNewVehicle() {
    final number = _vehNumberController.text.trim().toUpperCase();
    if (number.isEmpty || number.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid vehicle number')),
      );
      return;
    }
    setState(() {
      _userProfile['vehicles'].add({
        'number': number,
        'type': _vehType,
        'isDefault': _userProfile['vehicles'].isEmpty, // first becomes default
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vehicle $number added')),
    );
  }

  void _removeVehicle(Map<String, dynamic> vehicle) {
    setState(() {
      _userProfile['vehicles'].remove(vehicle);
      // ensure one default remains
      if (!_userProfile['vehicles'].any((v) => v['isDefault'] == true) &&
          _userProfile['vehicles'].isNotEmpty) {
        _userProfile['vehicles'][0]['isDefault'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${vehicle['number']} removed')),
    );
  }

  void _setDefaultVehicle(Map<String, dynamic> vehicle) {
    setState(() {
      for (final v in _userProfile['vehicles']) {
        v['isDefault'] = false;
      }
      vehicle['isDefault'] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${vehicle['number']} set as default')),
    );
  }

  void _changePasswordDialog() {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                prefixIcon: const Icon(Icons.lock_outline),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: newCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: const Icon(Icons.lock),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: confirmCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                prefixIcon: const Icon(Icons.lock),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
            onPressed: () {
              if (newCtrl.text != confirmCtrl.text || newCtrl.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match or too short')),
                );
                return;
              }
              // TODO: integrate with backend
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password changed successfully')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _chooseLanguageSheet() {
    final langs = ['English', 'हिंदी', 'తెలుగు', 'தமிழ்', 'ಕನ್ನಡ'];
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: langs
            .map(
              (l) => RadioListTile<String>(
            value: l,
            groupValue: _language,
            title: Text(l),
            onChanged: (val) {
              setState(() => _language = val ?? 'English');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Language set to $_language')),
              );
            },
          ),
        )
            .toList(),
      ),
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
              // TODO: clear tokens / navigate to login
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

  // ─────────────────────────────────────────────────────────────────────────────
  // UI
  // ─────────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 16),
            _buildStatsRow(),
            const SizedBox(height: 16),
            _buildQuickActions(),
            const SizedBox(height: 16),
            _buildAccountSection(),
            const SizedBox(height: 16),
            _buildPrivacySecuritySection(),
            const SizedBox(height: 16),
            _buildAppSettingsSection(),
            const SizedBox(height: 16),
            _buildSupportSection(),
            const SizedBox(height: 16),
            _buildLogoutButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: primaryColor.withOpacity(0.12),
                backgroundImage: _userProfile['profileImage'] != null
                    ? NetworkImage(_userProfile['profileImage'])
                    : null,
                child: _userProfile['profileImage'] == null
                    ? Icon(Icons.person, size: 42, color: primaryColor)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    // TODO: pick image
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Change photo tapped')),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.edit, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userProfile['name'],
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(_userProfile['email'], style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 2),
                Text(_userProfile['phone'], style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.verified, size: 16, color: Colors.green.shade700),
                    const SizedBox(width: 4),
                    Text(
                      'KYC ${_userProfile['kycStatus']} • Member since ${_userProfile['memberSince']}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit Profile',
            icon: Icon(Icons.edit, color: primaryColor),
            onPressed: _editProfileSheet,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            label: 'Bookings',
            value: _userProfile['totalBookings'].toString(),
            icon: Icons.book_online,
            color: Colors.green.shade600,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            label: 'Vehicles',
            value: _userProfile['vehicles'].length.toString(),
            icon: Icons.directions_car,
            color: primaryColor,
            onTap: _manageVehiclesSheet,
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _quickAction(icon: Icons.directions_car, label: 'Vehicles', onTap: _manageVehiclesSheet),
              _quickAction(icon: Icons.lock_reset, label: 'Password', onTap: _changePasswordDialog),
              _quickAction(icon: Icons.help_center, label: 'Support', onTap: _openHelpSupport),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: primaryColor),
          ),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Account',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          _settingsTile(
            icon: Icons.notifications,
            title: 'Notifications',
            trailing: Switch(
              activeColor: primaryColor,
              value: _notificationsEnabled,
              onChanged: (v) => setState(() => _notificationsEnabled = v),
            ),
          ),
          _settingsTile(
            icon: Icons.email,
            title: 'Email Updates',
            trailing: Switch(
              activeColor: primaryColor,
              value: _emailUpdates,
              onChanged: (v) => setState(() => _emailUpdates = v),
            ),
          ),
          _settingsTile(
            icon: Icons.sms,
            title: 'SMS Alerts',
            trailing: Switch(
              activeColor: primaryColor,
              value: _smsAlerts,
              onChanged: (v) => setState(() => _smsAlerts = v),
            ),
          ),
          _settingsTile(
            icon: Icons.directions_car,
            title: 'Manage Vehicles',
            trailing: const Icon(Icons.chevron_right),
            onTap: _manageVehiclesSheet,
          ),
          _settingsTile(
            icon: Icons.lock_reset,
            title: 'Change Password',
            trailing: const Icon(Icons.chevron_right),
            onTap: _changePasswordDialog,
          ),
        ],
      ),
    );
  }

  void _linkedAccountsSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Linked Accounts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SwitchListTile(
              activeColor: primaryColor,
              value: _linkedGoogle,
              onChanged: (v) => setState(() => _linkedGoogle = v),
              title: const Text('Google'),
              secondary: const Icon(Icons.g_mobiledata, size: 28),
            ),
            SwitchListTile(
              activeColor: primaryColor,
              value: _linkedApple,
              onChanged: (v) => setState(() => _linkedApple = v),
              title: const Text('Apple'),
              secondary: const Icon(Icons.apple, size: 24),
            ),
            const SizedBox(height: 6),
            const Text(
              'Linking accounts helps with quicker sign-in and recovery.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySecuritySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Privacy & Security',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          _settingsTile(
            icon: Icons.shield_moon,
            title: 'Two-Factor Authentication',
            trailing: Switch(
              activeColor: primaryColor,
              value: _twoFactorAuth,
              onChanged: (v) {
                setState(() => _twoFactorAuth = v);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('2FA ${v ? 'enabled' : 'disabled'}')),
                );
              },
            ),
          ),
          ExpansionTile(
            leading: const Icon(Icons.devices_other),
            title: const Text('Recent Logins'),
            children: _recentLogins
                .map(
                  (l) => ListTile(
                leading: const Icon(Icons.login),
                title: Text(l['device']!),
                subtitle: Text('${l['location']} • ${l['time']}'),
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('App Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          _settingsTile(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            trailing: Switch(
              activeColor: primaryColor,
              value: _darkMode,
              onChanged: (v) {
                setState(() => _darkMode = v);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Theme change will apply app-wide.')),
                );
              },
            ),
          ),
          _settingsTile(
            icon: Icons.language,
            title: 'Language',
            subtitle: _language,
            trailing: const Icon(Icons.chevron_right),
            onTap: _chooseLanguageSheet,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Support',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          _settingsTile(
            icon: Icons.help_center,
            title: 'Help & Support',
            trailing: const Icon(Icons.chevron_right),
            onTap: _openHelpSupport, // ✅ integrated HelpSupportPage
          ),
          _settingsTile(
            icon: Icons.star_rate,
            title: 'Rate Our App',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thanks for rating PARK-PRO!')),
              );
            },
          ),
          _settingsTile(
            icon: Icons.share,
            title: 'Share App',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share link copied to clipboard')),
              );
            },
          ),
          _settingsTile(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Open Privacy Policy')),
              );
            },
          ),
          _settingsTile(
            icon: Icons.description,
            title: 'Terms & Conditions',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Open Terms & Conditions')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _logout,
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text('Logout', style: TextStyle(color: Colors.red)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────────────────────
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: primaryColor),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
