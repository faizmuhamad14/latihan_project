import 'package:intl/intl.dart';

class CurrencyHelper {
  static final _rupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  static String format(int amount) {
    return _rupiah.format(amount);
  }
}
