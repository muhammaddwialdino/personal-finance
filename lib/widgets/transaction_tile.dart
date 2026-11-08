import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../utils/formatters.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? Colors.green.shade700 : Colors.red.shade700;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor:
            isIncome ? Colors.green.shade100 : Colors.red.shade100,
        child: Icon(
          isIncome ? Icons.arrow_downward : Icons.arrow_upward,
          color: color,
        ),
      ),
      title: Text(transaction.title),
      subtitle: Text(
        '${transaction.category} • ${formatDate(transaction.date)}',
      ),
      trailing: Text(
        '${isIncome ? '+' : '-'} ${formatRupiah(transaction.amount)}',
        style: TextStyle(fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}