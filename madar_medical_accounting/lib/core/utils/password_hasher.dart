import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

/// Salted, iterative HMAC-SHA256 password hashing (PBKDF2-style).
/// Pure Dart, no native dependencies - suitable for a local, offline,
/// single-device financial app. Not a substitute for a hardware secure
/// enclave, but far better than plaintext or a single unsalted hash.
class PasswordHasher {
  PasswordHasher._();

  static const int _iterations = 10000;
  static const int _keyLengthBytes = 32;

  static String generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64Url.encode(saltBytes);
  }

  static String hashPassword(String password, String salt) {
    final saltBytes = base64Url.decode(salt);
    List<int> derived = utf8.encode(password);
    for (int i = 0; i < _iterations; i++) {
      final hmac = Hmac(sha256, saltBytes);
      derived = hmac.convert(derived).bytes;
    }
    final truncated = derived.length > _keyLengthBytes
        ? derived.sublist(0, _keyLengthBytes)
        : derived;
    return base64Url.encode(truncated);
  }

  static bool verifyPassword(String password, String salt, String storedHash) {
    final computed = hashPassword(password, salt);
    return _constantTimeEquals(computed, storedHash);
  }

  static bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    int result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }
}
