import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/supplier_model.dart';
import '../../data/repositories/supplier_repository_impl.dart';
import '../../domain/repositories/supplier_repository.dart';

final supplierRepositoryProvider = Provider<SupplierRepository>((ref) => SupplierRepositoryImpl());

final supplierSearchProvider =
    FutureProvider.autoDispose.family<List<SupplierModel>, String>((ref, query) async {
  final repo = ref.watch(supplierRepositoryProvider);
  return repo.getAll(searchQuery: query);
});
