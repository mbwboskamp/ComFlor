import 'package:driversense_app/core/storage/database/app_database.dart';

abstract class CheckLocalDatasource {
  Future<void> cacheQuestions(List<Map<String, dynamic>> questions);
  Future<List<Map<String, dynamic>>> getCachedQuestions();
  Future<void> saveCheckLocally(Map<String, dynamic> check);
}

class CheckLocalDatasourceImpl implements CheckLocalDatasource {
  final AppDatabase _database;

  CheckLocalDatasourceImpl(this._database);

  @override
  Future<void> cacheQuestions(List<Map<String, dynamic>> questions) async {
    // TODO: Implement local caching
  }

  @override
  Future<List<Map<String, dynamic>>> getCachedQuestions() async {
    // TODO: Implement local caching
    return [];
  }

  @override
  Future<void> saveCheckLocally(Map<String, dynamic> check) async {
    // TODO: Implement local storage
  }
}
