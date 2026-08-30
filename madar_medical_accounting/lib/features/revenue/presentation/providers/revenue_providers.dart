import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/revenue_transaction_model.dart';
import '../../data/repositories/revenue_repository_impl.dart';
import '../../domain/repositories/revenue_repository.dart';

final revenueRepositoryProvider = Provider<RevenueRepository>((ref) => RevenueRepositoryImpl());

final revenueFilterProvider = StateProvider.autoDispose<RevenueFilter>((ref) => const RevenueFilter());

final revenueListProvider = FutureProvider.autoDispose<List<RevenueTransactionModel>>((ref) async {
  final filter = ref.watch(revenueFilterProvider);
  final repo = ref.watch(revenueRepositoryProvider);
  return repo.getAll(filter);
});
