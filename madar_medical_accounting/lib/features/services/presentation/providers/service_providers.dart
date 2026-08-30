import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/service_model.dart';
import '../../data/repositories/service_repository_impl.dart';
import '../../domain/repositories/service_repository.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) => ServiceRepositoryImpl());

final activeServicesProvider = FutureProvider.autoDispose<List<ServiceModel>>((ref) async {
  final repo = ref.watch(serviceRepositoryProvider);
  return repo.getAll(activeOnly: true);
});

final allServicesProvider = FutureProvider.autoDispose<List<ServiceModel>>((ref) async {
  final repo = ref.watch(serviceRepositoryProvider);
  return repo.getAll();
});
