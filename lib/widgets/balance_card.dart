import 'package:flutter/material.dart';

import '../utils/formatters.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Saldo', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(
            formatRupiah(balance),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.onPrimaryContainer,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _Stat(
                label: 'Masuk',
                value: income,
                color: Colors.green.shade700,
                icon: Icons.arrow_downward,
              ),
              const SizedBox(width: 24),
              _Stat(
                label: 'Keluar',
                value: expense,
                color: Colors.red.shade700,
                icon: Icons.arrow_upward,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;

  const _Stat({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            Text(
              formatRupiah(value),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}