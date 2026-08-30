import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/doctor_model.dart';
import '../../data/repositories/doctor_repository_impl.dart';
import '../../domain/doctor_stats_service.dart';
import '../../domain/repositories/doctor_repository.dart';

final doctorRepositoryProvider = Provider<DoctorRepository>((ref) => DoctorRepositoryImpl());

final activeDoctorsProvider = FutureProvider.autoDispose<List<DoctorModel>>((ref) async {
  final repo = ref.watch(doctorRepositoryProvider);
  return repo.getAll(activeOnly: true);
});

final allDoctorsProvider = FutureProvider.autoDispose<List<DoctorModel>>((ref) async {
  final repo = ref.watch(doctorRepositoryProvider);
  return repo.getAll();
});

final doctorStatsServiceProvider = Provider<DoctorStatsService>((ref) => DoctorStatsService());

final doctorRevenueSummaryProvider =
    FutureProvider.autoDispose.family<DoctorRevenueSummary, int>((ref, doctorId) async {
  final service = ref.watch(doctorStatsServiceProvider);
  return service.getSummary(doctorId);
});
