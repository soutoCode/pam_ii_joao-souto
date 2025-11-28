import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService{
  // Singleton Pattern
  static final AuthService instance=AuthService._constructor();
  AuthService._constructor();

  static String _ACCESS_TOKEY_KEY='access-token';

  final _storage=FlutterSecureStorage();

  // Save Access Token
  Future<void> saveAccessToken({required String accessToken})async{
    await _storage.write(key:AuthService._ACCESS_TOKEY_KEY,value:accessToken);
  }

  // Retreat Access Token
  Future<String?> getAccessToken()async{
    return await _storage.read(key:AuthService._ACCESS_TOKEY_KEY);
  }

  // Log out (Delete from Storage)
  Future<void> logout()async{
    await _storage.delete(key:AuthService._ACCESS_TOKEY_KEY);
  }
}
