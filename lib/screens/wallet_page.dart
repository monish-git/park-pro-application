import 'package:flutter/material.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  double _balance = 1250.75;
  int _rewardPoints = 475;

  // Mock transaction history
  final List<Map<String, dynamic>> _transactions = [
    {
      'id': '1',
      'type': 'credit',
      'amount': 500.0,
      'description': 'Wallet Top-up',
      'date': '2025-08-24',
      'time': '14:30',
      'icon': Icons.account_balance_wallet,
    },
    {
      'id': '2',
      'type': 'debit',
      'amount': 240.0,
      'description': 'Downtown Mall Parking',
      'date': '2025-08-23',
      'time': '18:15',
      'icon': Icons.local_parking,
    },
    {
      'id': '3',
      'type': 'credit',
      'amount': 50.0,
      'description': 'Cashback Reward',
      'date': '2025-08-22',
      'time': '09:45',
      'icon': Icons.card_giftcard,
    },
    {
      'id': '4',
      'type': 'debit',
      'amount': 320.0,
      'description': 'IT Park Block C',
      'date': '2025-08-21',
      'time': '17:30',
      'icon': Icons.local_parking,
    },
    {
      'id': '5',
      'type': 'credit',
      'amount': 1000.0,
      'description': 'Wallet Top-up',
      'date': '2025-08-20',
      'time': '11:20',
      'icon': Icons.account_balance_wallet,
    },
  ];

  void _showAddMoneySheet() {
    final amounts = [100, 200, 500, 1000, 2000];

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
                'Add Money to Wallet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Quick Add',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: amounts.map((amount) {
                  return ActionChip(
                    label: Text('₹$amount'),
                    onPressed: () {
                      _addMoney(amount.toDouble());
                      Navigator.pop(context);
                    },
                    backgroundColor: Colors.blue.shade50,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Custom Amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  hintText: 'Enter amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  final amount = double.tryParse(value) ?? 0;
                  if (amount > 0) {
                    _addMoney(amount);
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _addMoney(double amount) {
    setState(() {
      _balance += amount;
      _transactions.insert(0, {
        'id': '${DateTime.now().millisecondsSinceEpoch}',
        'type': 'credit',
        'amount': amount,
        'description': 'Wallet Top-up',
        'date': '2025-08-24', // Use current date in real app
        'time': 'Now',
        'icon': Icons.account_balance_wallet,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('₹$amount added to wallet successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Color _getTransactionColor(String type) {
    return type == 'credit' ? Colors.green : Colors.red;
  }

  IconData _getTransactionIcon(String type) {
    return type == 'credit' ? Icons.arrow_downward : Icons.arrow_upward;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Wallet',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Balance Card
          _buildBalanceCard(),
          // Rewards Card
          _buildRewardsCard(),
          // Transactions Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.history),
                  onPressed: () {
                    // Show full transaction history
                  },
                  tooltip: 'View all transactions',
                ),
              ],
            ),
          ),
          // Transactions List
          Expanded(
            child: _transactions.isEmpty
                ? _buildEmptyTransactions()
                : _buildTransactionsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade800, Colors.blue.shade600],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade300,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Current Balance',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₹$_balance',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _showAddMoneySheet,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue.shade800,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'Add Money',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.card_giftcard, color: Colors.amber.shade700, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reward Points',
                  style: TextStyle(
                    color: Colors.amber.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$_rewardPoints points',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹${(_rewardPoints / 10).toStringAsFixed(0)} value',
            style: TextStyle(
              color: Colors.amber.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTransactions() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 60,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions yet',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final transaction = _transactions[index];
        return _buildTransactionItem(transaction);
      },
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      child: ListTile(
        leading: Icon(
          transaction['icon'],
          color: _getTransactionColor(transaction['type']),
        ),
        title: Text(transaction['description']),
        subtitle: Text('${transaction['date']} at ${transaction['time']}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${transaction['type'] == 'credit' ? '+' : '-'}₹${transaction['amount']}',
              style: TextStyle(
                color: _getTransactionColor(transaction['type']),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Icon(
              _getTransactionIcon(transaction['type']),
              size: 16,
              color: _getTransactionColor(transaction['type']),
            ),
          ],
        ),
      ),
    );
  }
}