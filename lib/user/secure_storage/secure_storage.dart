import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final PERSONAL_KEY = 'PersonalKey';
final REFRESH_TOKEN = 'RefreshToken';
final ACCESS_TOKEN = 'AccessToken';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) => FlutterSecureStorage());
