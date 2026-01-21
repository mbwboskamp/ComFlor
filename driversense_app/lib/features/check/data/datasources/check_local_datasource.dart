import 'package:driversense_app/core/storage/database/app_database.dart';
import 'package:driversense_app/features/check/domain/entities/check.dart' as domain;

/// Local data source for check operations
abstract class CheckLocalDatasource {
  /// Get cached questions
  Future<List<domain.Question>> getCachedQuestions({
    required domain.CheckType checkType,
  });

  /// Cache questions
  Future<void> cacheQuestions(List<domain.Question> questions);

  /// Get local check by ID
  Future<domain.Check?> getCheckById(String checkId);

  /// Save check locally
  Future<void> saveCheck(domain.Check check);

  /// Get checks for trip
  Future<List<domain.Check>> getChecksForTrip(String tripId);
}

/// Implementation of CheckLocalDatasource
class CheckLocalDatasourceImpl implements CheckLocalDatasource {
  final AppDatabase _database;

  CheckLocalDatasourceImpl(this._database);

  @override
  Future<List<domain.Question>> getCachedQuestions({
    required domain.CheckType checkType,
  }) async {
    final dao = _database.questionsDao;
    final questions = await dao.getQuestionsByCheckType(checkType.name);

    return questions.map((q) => domain.Question(
      id: q.id,
      code: q.code,
      category: q.category,
      text: q.questionText,
      type: domain.QuestionType.scale, // Default to scale
      scaleLabels: _parseScaleLabels(q.scaleLabels),
      sortOrder: q.sortOrder,
      isRequired: true,
    )).toList();
  }

  @override
  Future<void> cacheQuestions(List<domain.Question> questions) async {
    // Questions are cached via the QuestionsDao
    // This would convert domain questions to database companions
    // For now, this is a stub
  }

  @override
  Future<domain.Check?> getCheckById(String checkId) async {
    final dao = _database.checksDao;
    final check = await dao.getCheckById(checkId);

    if (check == null) return null;

    return domain.Check(
      id: check.id,
      tripId: check.tripId,
      driverId: check.driverId,
      type: check.checkType == 'start' ? domain.CheckType.start : domain.CheckType.end,
      status: _parseStatus(check.status),
      answers: [], // Would need to load from a separate table
      startedAt: check.startedAt,
      completedAt: check.completedAt,
      notes: check.notes,
    );
  }

  @override
  Future<void> saveCheck(domain.Check check) async {
    // Save check to local database
    // This is a stub for now
  }

  @override
  Future<List<domain.Check>> getChecksForTrip(String tripId) async {
    final dao = _database.checksDao;
    final checks = await dao.getChecksByTripId(tripId);

    return checks.map((check) => domain.Check(
      id: check.id,
      tripId: check.tripId,
      driverId: check.driverId,
      type: check.checkType == 'start' ? domain.CheckType.start : domain.CheckType.end,
      status: _parseStatus(check.status),
      answers: [],
      startedAt: check.startedAt,
      completedAt: check.completedAt,
      notes: check.notes,
    )).toList();
  }

  Map<int, String> _parseScaleLabels(String json) {
    // Parse JSON string to map
    // For now, return default labels
    return {
      1: 'Slecht',
      2: 'Matig',
      3: 'Gemiddeld',
      4: 'Goed',
      5: 'Uitstekend',
    };
  }

  domain.CheckStatus _parseStatus(String status) {
    switch (status) {
      case 'pending':
        return domain.CheckStatus.pending;
      case 'in_progress':
        return domain.CheckStatus.inProgress;
      case 'completed':
        return domain.CheckStatus.completed;
      case 'cancelled':
        return domain.CheckStatus.cancelled;
      default:
        return domain.CheckStatus.pending;
    }
  }
}
