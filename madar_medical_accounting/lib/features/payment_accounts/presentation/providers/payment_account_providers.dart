import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/payment_account_model.dart';
import '../../data/models/payment_method_model.dart';
import '../../data/repositories/payment_account_repository_impl.dart';
import '../../domain/repositories/payment_account_repository.dart';

final paymentAccountRepositoryProvider =
    Provider<PaymentAccountRepository>((ref) => PaymentAccountRepositoryImpl());

final activePaymentMethodsProvider = FutureProvider.autoDispose<List<PaymentMethodModel>>((ref) async {
  final repo = ref.watch(paymentAccountRepositoryProvider);
  return repo.getAllMethods(activeOnly: true);
});

final allPaymentAccountsProvider = FutureProvider.autoDispose<List<PaymentAccountModel>>((ref) async {
  final repo = ref.watch(paymentAccountRepositoryProvider);
  return repo.getAllAccounts();
});
