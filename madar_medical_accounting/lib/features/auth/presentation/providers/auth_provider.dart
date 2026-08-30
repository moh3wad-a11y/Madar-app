import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepositoryImpl());

final allUsersProvider = FutureProvider.autoDispose<List<UserModel>>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  return repo.getAllUsers();
});

class AuthState {
  final UserModel? currentUser;
  final bool isLoading;
  final String? errorMessage;
  final bool sessionRestored;

  const AuthState({
    this.currentUser,
    this.isLoading = false,
    this.errorMessage,
    this.sessionRestored = false,
  });

  bool get isLoggedIn => currentUser != null;

  AuthState copyWith({
    UserModel? currentUser,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool clearUser = false,
    bool? sessionRestored,
  }) {
    return AuthState(
      currentUser: clearUser ? null : (currentUser ?? this.currentUser),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      sessionRestored: sessionRestored ?? this.sessionRestored,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState()) {
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _repository.getCurrentUser();
      state = state.copyWith(
        currentUser: user,
        isLoading: false,
        clearError: true,
        sessionRestored: true,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false, sessionRestored: true);
    }
  }

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.login(username, password);
      state = state.copyWith(currentUser: user, isLoading: false, clearError: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = state.copyWith(clearUser: true);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
