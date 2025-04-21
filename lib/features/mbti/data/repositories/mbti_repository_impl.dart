import '../../domain/entities/mbti_question.dart';
import '../../domain/repositories/mbti_repository.dart';
import '../datasources/mbti_remote_data_source.dart';

class MbtiRepositoryImpl implements MbtiRepository {
  final MbtiRemoteDataSource dataSource;

  MbtiRepositoryImpl(this.dataSource);

  @override
  Future<List<MbtiQuestion>> fetchQuestions(int page) {
    return dataSource.fetchQuestions(page);
  }
}
