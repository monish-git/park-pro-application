import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Notification categories
  String _selectedCategory = 'all';

  // Mock notifications data
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'type': 'booking',
      'title': 'Booking Confirmed',
      'message': 'Your booking at Downtown Mall Parking is confirmed for today at 14:00',
      'time': '2 minutes ago',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 2)),
      'isRead': false,
      'icon': Icons.book_online,
      'color': Colors.green,
      'action': 'view_booking',
    },
    {
      'id': '2',
      'type': 'promotion',
      'title': 'Special Offer!',
      'message': 'Get 50% off on evening parking from 5 PM to 10 PM this weekend',
      'time': '1 hour ago',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'isRead': false,
      'icon': Icons.local_offer,
      'color': Colors.orange,
      'action': 'view_offer',
    },
    {
      'id': '3',
      'type': 'reminder',
      'title': 'Booking Reminder',
      'message': 'Your parking at IT Park Block C starts in 30 minutes',
      'time': '3 hours ago',
      'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
      'isRead': true,
      'icon': Icons.notifications_active,
      'color': Colors.blue,
      'action': 'view_booking',
    },
    {
      'id': '4',
      'type': 'payment',
      'title': 'Payment Received',
      'message': 'Payment of ₹240 for Downtown Mall Parking has been received',
      'time': '5 hours ago',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'isRead': true,
      'icon': Icons.payment,
      'color': Colors.purple,
      'action': 'view_receipt',
    },
    {
      'id': '5',
      'type': 'system',
      'title': 'App Update',
      'message': 'New version 2.1.0 is available with exciting features',
      'time': '1 day ago',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': true,
      'icon': Icons.system_update,
      'color': Colors.blueGrey,
      'action': 'update_app',
    },
    {
      'id': '6',
      'type': 'security',
      'title': 'Security Alert',
      'message': 'Your vehicle TS09AB1234 has been detected entering the parking facility',
      'time': '2 days ago',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'isRead': true,
      'icon': Icons.security,
      'color': Colors.red,
      'action': 'view_security',
    },
    {
      'id': '7',
      'type': 'booking',
      'title': 'Extended Successfully',
      'message': 'Your parking at Airport Terminal A has been extended by 2 hours',
      'time': '3 days ago',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'isRead': true,
      'icon': Icons.timer,
      'color': Colors.green,
      'action': 'view_booking',
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedCategory == 'all') return _notifications;
    return _notifications.where((notification) => notification['type'] == _selectedCategory).toList();
  }

  int get _unreadCount {
    return _notifications.where((notification) => !notification['isRead']).length;
  }

  void _markAsRead(String id) {
    setState(() {
      final notification = _notifications.firstWhere((n) => n['id'] == id);
      notification['isRead'] = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All'),
        content: const Text('Are you sure you want to clear all notifications?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _notifications.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications cleared')),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handleNotificationAction(Map<String, dynamic> notification) {
    _markAsRead(notification['id']);

    switch (notification['action']) {
      case 'view_booking':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening booking: ${notification['title']}')),
        );
        break;
      case 'view_offer':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Viewing special offer')),
        );
        break;
      case 'view_receipt':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening payment receipt')),
        );
        break;
      case 'update_app':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Taking to app update')),
        );
        break;
      case 'view_security':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Viewing security details')),
        );
        break;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'booking':
        return Colors.blue.shade800;
      case 'promotion':
        return Colors.orange.shade800;
      case 'reminder':
        return Colors.green.shade800;
      case 'payment':
        return Colors.purple.shade800;
      case 'system':
        return Colors.blueGrey.shade800;
      case 'security':
        return Colors.red.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'booking':
        return 'Bookings';
      case 'promotion':
        return 'Promotions';
      case 'reminder':
        return 'Reminders';
      case 'payment':
        return 'Payments';
      case 'system':
        return 'System';
      case 'security':
        return 'Security';
      default:
        return 'All';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (_unreadCount > 0)
            IconButton(
              icon: Badge(
                label: Text(_unreadCount.toString()),
                child: const Icon(Icons.mark_email_read),
              ),
              onPressed: _markAllAsRead,
              tooltip: 'Mark all as read',
            ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _clearAllNotifications,
            tooltip: 'Clear all notifications',
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter Chips
          _buildCategoryFilter(),
          const SizedBox(height: 8),

          // Notifications List
          Expanded(
            child: _filteredNotifications.isEmpty
                ? _buildEmptyState()
                : _buildNotificationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = ['all', 'booking', 'promotion', 'reminder', 'payment', 'security', 'system'];

    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(_getCategoryLabel(category)),
              selected: _selectedCategory == category,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected ? category : 'all';
                });
              },
              backgroundColor: Colors.grey.shade200,
              selectedColor: _getCategoryColor(category),
              labelStyle: TextStyle(
                color: _selectedCategory == category ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _selectedCategory == 'all'
                ? 'You\'re all caught up!'
                : 'No ${_getCategoryLabel(_selectedCategory).toLowerCase()} notifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: _filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = _filteredNotifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    return Dismissible(
      key: Key(notification['id']),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      secondaryBackground: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.mark_email_read, color: Colors.white, size: 30),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Delete
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Notification'),
              content: const Text('Are you sure you want to delete this notification?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
        } else {
          // Mark as read
          _markAsRead(notification['id']);
          return false;
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          setState(() {
            _notifications.removeWhere((n) => n['id'] == notification['id']);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notification deleted')),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        elevation: 1,
        color: notification['isRead'] ? Colors.white : Colors.blue.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: notification['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              notification['icon'],
              color: notification['color'],
              size: 24,
            ),
          ),
          title: Text(
            notification['title'],
            style: TextStyle(
              fontWeight: notification['isRead'] ? FontWeight.normal : FontWeight.bold,
              color: notification['isRead'] ? Colors.grey.shade700 : Colors.black,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                notification['message'],
                style: TextStyle(
                  color: notification['isRead'] ? Colors.grey.shade600 : Colors.grey.shade800,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                notification['time'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          trailing: !notification['isRead']
              ? const Badge(
            smallSize: 12,
            backgroundColor: Colors.red,
          )
              : null,
          onTap: () => _handleNotificationAction(notification),
          onLongPress: () => _markAsRead(notification['id']),
        ),
      ),
    );
  }
}