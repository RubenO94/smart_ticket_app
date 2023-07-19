import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/services/api.dart';

final apiServiceProvider = Provider((ref) => ApiService(ref));
