import 'package:driversense_app/core/network/api_client.dart';
import 'package:driversense_app/features/check/domain/entities/check.dart';

/// Remote data source for check operations
abstract class CheckRemoteDatasource {
  /// Get questions from server
  Future<List<Question>> getQuestions({required CheckType checkType});

  /// Submit start check to server
  Future<Check> submitStartCheck({
    required String tripId,
    required List<CheckAnswer> answers,
    String? notes,
  });

  /// Submit end check to server
  Future<Check> submitEndCheck({
    required String tripId,
    required List<CheckAnswer> answers,
    String? notes,
  });

  /// Get check by ID from server
  Future<Check> getCheckById(String checkId);
}

/// Implementation of CheckRemoteDatasource
class CheckRemoteDatasourceImpl implements CheckRemoteDatasource {
  final ApiClient _apiClient;

  CheckRemoteDatasourceImpl(this._apiClient);

  @override
  Future<List<Question>> getQuestions({required CheckType checkType}) async {
    final response = await _apiClient.get(
      '/checks/questions',
      queryParameters: {'type': checkType.name},
    );

    final List<dynamic> data = response.data['questions'] ?? [];
    return data.map((json) => _questionFromJson(json)).toList();
  }

  @override
  Future<Check> submitStartCheck({
    required String tripId,
    required List<CheckAnswer> answers,
    String? notes,
  }) async {
    final response = await _apiClient.post(
      '/checks/start',
      data: {
        'trip_id': tripId,
        'answers': answers.map((a) => _answerToJson(a)).toList(),
        if (notes != null) 'notes': notes,
      },
    );

    return _checkFromJson(response.data);
  }

  @override
  Future<Check> submitEndCheck({
    required String tripId,
    required List<CheckAnswer> answers,
    String? notes,
  }) async {
    final response = await _apiClient.post(
      '/checks/end',
      data: {
        'trip_id': tripId,
        'answers': answers.map((a) => _answerToJson(a)).toList(),
        if (notes != null) 'notes': notes,
      },
    );

    return _checkFromJson(response.data);
  }

  @override
  Future<Check> getCheckById(String checkId) async {
    final response = await _apiClient.get('/checks/$checkId');
    return _checkFromJson(response.data);
  }

  Question _questionFromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      code: json['code'] as String,
      category: json['category'] as String,
      text: json['text'] as String,
      type: QuestionType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => QuestionType.scale,
      ),
      scaleLabels: (json['scale_labels'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(int.parse(k), v as String),
          ) ??
          {},
      sortOrder: json['sort_order'] as int? ?? 0,
      isRequired: json['is_required'] as bool? ?? true,
    );
  }

  Check _checkFromJson(Map<String, dynamic> json) {
    return Check(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      driverId: json['driver_id'] as String,
      type: CheckType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => CheckType.start,
      ),
      status: CheckStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => CheckStatus.completed,
      ),
      answers: (json['answers'] as List<dynamic>?)
              ?.map((a) => _answerFromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
      startedAt: DateTime.parse(json['started_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      notes: json['notes'] as String?,
    );
  }

  CheckAnswer _answerFromJson(Map<String, dynamic> json) {
    return CheckAnswer(
      questionId: json['question_id'] as String,
      value: json['value'],
      answeredAt: DateTime.parse(json['answered_at'] as String),
    );
  }

  Map<String, dynamic> _answerToJson(CheckAnswer answer) {
    return {
      'question_id': answer.questionId,
      'value': answer.value,
      'answered_at': answer.answeredAt.toIso8601String(),
    };
  }
}
