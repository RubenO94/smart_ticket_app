import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

String formattedDate(DateTime data) {
  initializeDateFormatting();
  Intl.defaultLocale = 'pt_PT';
  final formato = DateFormat('dd/MMM/yyyy', 'pt_PT');
  return formato.format(data);
}
