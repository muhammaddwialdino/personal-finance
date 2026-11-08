import 'package:intl/intl.dart';

final _currency = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

String formatRupiah(num value) => _currency.format(value);

String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);