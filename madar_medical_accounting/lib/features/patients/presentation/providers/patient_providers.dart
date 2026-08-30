import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/patient_model.dart';
import '../../data/repositories/patient_repository_impl.dart';
import '../../domain/repositories/patient_repository.dart';

final patientRepositoryProvider = Provider<PatientRepository>((ref) => PatientRepositoryImpl());

final patientSearchProvider =
    FutureProvider.autoDispose.family<List<PatientModel>, String>((ref, query) async {
  final repo = ref.watch(patientRepositoryProvider);
  return repo.getAll(searchQuery: query);
});
