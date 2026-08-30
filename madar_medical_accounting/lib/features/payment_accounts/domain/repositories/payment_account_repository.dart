import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../data/models/payment_account_model.dart';
import '../../data/models/payment_method_model.dart';

abstract class PaymentAccountRepository {
  Future<List<PaymentAccountModel>> getAllAccounts();
  Future<PaymentAccountModel?> getAccountById(int id);
  Future<List<PaymentMethodModel>> getAllMethods({bool activeOnly = false});
  Future<PaymentMethodModel?> getMethodById(int id);

  /// Adds [delta] to the balance of the account that [paymentMethodId] posts
  /// to. Positive delta = inflow (revenue), negative = outflow (expense).
  /// Accepts an optional [executor] so it can run inside a parent
  /// transaction (e.g. alongside inserting the revenue row itself) and stay
  /// atomic - the balance must never be able to drift from the transaction
  /// tables it's derived from.
  Future<void> applyBalanceDelta(
    int paymentMethodId,
    double delta, {
    DatabaseExecutor? executor,
  });

  Future<void> createMethod(PaymentMethodModel method, {required int userId});
  Future<void> setMethodActive(int id, bool isActive, {required int userId});
}
