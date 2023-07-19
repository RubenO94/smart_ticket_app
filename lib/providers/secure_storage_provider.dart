import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/services/secure_storage.dart';

final secureStorageProvider = Provider((ref) => SecureStorageService());
