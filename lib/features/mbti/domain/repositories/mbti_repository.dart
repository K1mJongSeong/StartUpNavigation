import '../entities/mbti_question.dart';

abstract class MbtiRepository {
  Future<List<MbtiQuestion>> fetchQuestions(int page);
}
