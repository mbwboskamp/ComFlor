import 'package:driversense_app/core/network/api_client.dart';

abstract class CheckRemoteDatasource {
  Future<List<Map<String, dynamic>>> getQuestions(String checkType);
  Future<void> submitStartCheck(Map<String, dynamic> data);
  Future<void> submitEndCheck(Map<String, dynamic> data);
}

class CheckRemoteDatasourceImpl implements CheckRemoteDatasource {
  final ApiClient _apiClient;

  CheckRemoteDatasourceImpl(this._apiClient);

  @override
  Future<List<Map<String, dynamic>>> getQuestions(String checkType) async {
    // TODO: Implement API call
    return [];
  }

  @override
  Future<void> submitStartCheck(Map<String, dynamic> data) async {
    // TODO: Implement API call
  }

  @override
  Future<void> submitEndCheck(Map<String, dynamic> data) async {
    // TODO: Implement API call
  }
}
