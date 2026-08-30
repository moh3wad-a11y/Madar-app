class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() => message;
}

class ValidationException extends AppException {
  ValidationException(super.message) : super(code: 'validation_error');
}

class AuthException extends AppException {
  AuthException(super.message) : super(code: 'auth_error');
}

class PermissionDeniedException extends AppException {
  PermissionDeniedException(super.message) : super(code: 'permission_denied');
}

class NotFoundException extends AppException {
  NotFoundException(super.message) : super(code: 'not_found');
}
