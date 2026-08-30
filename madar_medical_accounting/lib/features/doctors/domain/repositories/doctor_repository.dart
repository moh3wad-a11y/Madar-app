import '../../data/models/doctor_model.dart';

abstract class DoctorRepository {
  Future<List<DoctorModel>> getAll({bool activeOnly = false});
  Future<DoctorModel?> getById(int id);
  Future<DoctorModel> create(DoctorModel doctor, {required int userId});
  Future<void> update(DoctorModel doctor, {required int userId});
  Future<void> setActive(int id, bool isActive, {required int userId});
}
