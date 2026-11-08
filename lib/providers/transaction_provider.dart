import 'package:flutter/foundation.dart';

import '../data/transaction_repository.dart';
import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _repo;
  TransactionProvider(this._repo);

  List<Transaction> _transactions = [];
  bool _loading = true;

  List<Transaction> get transactions => List.unmodifiable(_transactions);
  bool get loading => _loading;

  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (s, t) => s + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (s, t) => s + t.amount);

  double get balance => totalIncome - totalExpense;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _transactions = await _repo.getAll();
    _loading = false;
    notifyListeners();
  }

  Future<void> add(Transaction t) async {
    final saved = await _repo.insert(t);
    _transactions = [saved, ..._transactions]
      ..sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  Future<void> remove(int id) async {
  final backup = _transactions.where((t) => t.id == id).toList();
  _transactions = _transactions.where((t) => t.id != id).toList();
  notifyListeners(); // hilang dari UI dulu

  try {
    await _repo.delete(id);
  } catch (_) {
    // rollback kalau DB gagal
    _transactions = [..._transactions, ...backup]
      ..sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
    rethrow;
  }
}
}