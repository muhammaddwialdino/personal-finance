import '../models/transaction.dart';
import 'database_helper.dart';

class TransactionRepository {
  final DatabaseHelper _db;

  TransactionRepository({DatabaseHelper? db}) : _db = db ?? DatabaseHelper.instance;

  Future<List<Transaction>> getAll() async {
    final db = await _db.database;
    final rows = await db.query('transactions', orderBy: 'date DESC, id DESC');
    return rows.map(Transaction.fromMap).toList();
  }

  Future<Transaction> insert(Transaction t) async {
    final db = await _db.database;
    final map = t.toMap()..remove('id');
    final id = await db.insert('transactions', map);
    return t.copyWith(id: id);
  }

  Future<void> delete(int id) async {
    final db = await _db.database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}