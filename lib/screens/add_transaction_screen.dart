import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../utils/formatters.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  String _category = 'Makan';
  DateTime _date = DateTime.now();
  bool _saving = false;

  static const _expenseCategories = [
    'Makan', 'Transport', 'Belanja', 'Tagihan', 'Hiburan', 'Kesehatan', 'Lainnya',
  ];
  static const _incomeCategories = ['Gaji', 'Bonus', 'Investasi', 'Lainnya'];

  List<String> get _categories =>
      _type == TransactionType.income ? _incomeCategories : _expenseCategories;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onTypeChanged(TransactionType type) {
    setState(() {
      _type = type;
      if (!_categories.contains(_category)) _category = _categories.first;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    await context.read<TransactionProvider>().add(Transaction(
          title: _titleController.text.trim(),
          amount: double.parse(_amountController.text),
          type: _type,
          category: _category,
          date: _date,
        ));

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SegmentedButton<TransactionType>(
              segments: const [
                ButtonSegment(
                  value: TransactionType.expense,
                  label: Text('Pengeluaran'),
                  icon: Icon(Icons.arrow_upward),
                ),
                ButtonSegment(
                  value: TransactionType.income,
                  label: Text('Pemasukan'),
                  icon: Icon(Icons.arrow_downward),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (s) => _onTypeChanged(s.first),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Judul wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Jumlah',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final value = double.tryParse(v ?? '');
                if (value == null || value <= 0) {
                  return 'Masukkan jumlah yang valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today),
              label: Text(formatDate(_date)),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}