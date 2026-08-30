import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(String username, String password);
  Future<UserModel?> getCurrentUser();
  Future<void> logout();
  Future<void> changePassword(int userId, String currentPassword, String newPassword);

  /// Owner-only administrative reset: sets a new password for another
  /// user WITHOUT knowing their current one. Distinct from
  /// changePassword, which is the self-service flow and requires the
  /// current password as proof of identity.
  Future<void> resetPassword(int userId, String newPassword);

  Future<List<UserModel>> getAllUsers();
  Future<UserModel> createUser(UserModel user, String plainPassword);
  Future<void> updateUser(UserModel user);
  Future<void> setUserActive(int userId, bool isActive);
}
