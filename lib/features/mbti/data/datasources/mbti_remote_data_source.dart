import 'package:dio/dio.dart';

import '../../../../core/api/end_points.dart';
import '../models/mbti_question_model.dart';

class MbtiRemoteDataSource {
  final Dio dio;

  MbtiRemoteDataSource(this.dio);

  Future<List<MbtiQuestionModel>> fetchQuestions(int page) async {
    final response = await dio.get(EndPoints.mbtiTest(page));

    final data = response.data['data'];
    final questionList = data['questions'] as List;

    return questionList
        .map((json) => MbtiQuestionModel.fromJson(json))
        .toList();
  }
}
