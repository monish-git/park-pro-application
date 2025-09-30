import 'package:flutter/material.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample transactions
    final List<Map<String, String>> transactions = [
      {"title": "NH44 Toll", "date": "01 Sep 2025", "amount": "- ₹120"},
      {"title": "Recharge", "date": "28 Aug 2025", "amount": "+ ₹500"},
      {"title": "City Toll", "date": "27 Aug 2025", "amount": "- ₹60"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Transaction History"), backgroundColor: Colors.blueAccent),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final txn = transactions[index];
          final isCredit = txn['amount']!.contains("+");
          return ListTile(
            leading: Icon(isCredit ? Icons.arrow_downward : Icons.arrow_upward, color: isCredit ? Colors.green : Colors.red),
            title: Text(txn['title']!),
            subtitle: Text(txn['date']!),
            trailing: Text(txn['amount']!, style: TextStyle(color: isCredit ? Colors.green : Colors.red)),
          );
        },
      ),
    );
  }
}
