import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_tile.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('DompetKu')),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: provider.load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  BalanceCard(
                    balance: provider.balance,
                    income: provider.totalIncome,
                    expense: provider.totalExpense,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Transaksi',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (provider.transactions.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(
                        child: Text('Belum ada transaksi. Tekan + untuk mulai.'),
                      ),
                    )
                  else
                    ...provider.transactions.map(
                      (t) => Dismissible(
                        key: ValueKey(t.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => provider.remove(t.id!),
                        child: TransactionTile(transaction: t),
                      ),
                    ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}