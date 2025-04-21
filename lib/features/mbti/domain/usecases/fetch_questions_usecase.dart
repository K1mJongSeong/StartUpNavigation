import '../entities/mbti_question.dart';
import '../repositories/mbti_repository.dart';

class FetchMbtiQuestionsUseCase {
  final MbtiRepository repository;

  FetchMbtiQuestionsUseCase(this.repository);

  Future<List<MbtiQuestion>> call(int page) {
    return repository.fetchQuestions(page);
  }
}
