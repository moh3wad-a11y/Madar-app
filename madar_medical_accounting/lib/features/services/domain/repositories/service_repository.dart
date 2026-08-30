import '../../data/models/service_model.dart';

abstract class ServiceRepository {
  Future<List<ServiceModel>> getAll({bool activeOnly = false});
  Future<ServiceModel?> getById(int id);
  Future<ServiceModel> create(ServiceModel service, {required int userId});
  Future<void> update(ServiceModel service, {required int userId});
  Future<void> setActive(int id, bool isActive, {required int userId});
}
