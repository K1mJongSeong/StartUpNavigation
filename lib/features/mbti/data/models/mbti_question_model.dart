
import '../../domain/entities/mbti_question.dart';

class MbtiQuestionModel extends MbtiQuestion {
  MbtiQuestionModel({
    required int idx,
    required String text,
    required String category,
    required double weight,
    int? selectedScore,
  }) : super(
    idx: idx,
    text: text,
    category: category,
    weight: weight,
    selectedScore: selectedScore,
  );

  factory MbtiQuestionModel.fromJson(Map<String, dynamic> json) {
    return MbtiQuestionModel(
      idx: json['idx'],
      text: json['text'],
      category: json['category'],
      weight: double.tryParse(json['weight'].toString()) ?? 1.0,
      selectedScore: json['selectedScore'],
    );
  }
}
