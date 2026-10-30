enum TransactionType { income, expense }

class Transaction {
  final int? id;
  final String title;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;

  const Transaction({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'amount': amount,
        'type': type.name,
        'category': category,
        'date': date.toIso8601String(),
      };

  factory Transaction.fromMap(Map<String, Object?> map) => Transaction(
        id: map['id'] as int?,
        title: map['title'] as String,
        amount: (map['amount'] as num).toDouble(),
        type: TransactionType.values.byName(map['type'] as String),
        category: map['category'] as String,
        date: DateTime.parse(map['date'] as String),
      );

  Transaction copyWith({int? id}) => Transaction(
        id: id ?? this.id,
        title: title,
        amount: amount,
        type: type,
        category: category,
        date: date,
      );
}