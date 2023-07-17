import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/services/secure_storage.dart';

class StorageProvider extends StateNotifier<SecureStorageService> {
  StorageProvider(super.state);
  
}