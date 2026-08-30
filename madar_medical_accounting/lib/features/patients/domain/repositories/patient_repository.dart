import '../../data/models/patient_model.dart';

abstract class PatientRepository {
  Future<List<PatientModel>> getAll({String? searchQuery});
  Future<PatientModel?> getById(int id);
  Future<PatientModel> create(PatientModel patient, {required int userId});
  Future<void> update(PatientModel patient, {required int userId});
}
