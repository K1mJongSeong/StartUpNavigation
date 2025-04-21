abstract class MbtiQuestionEvent {}

class LoadMbtiQuestions extends MbtiQuestionEvent {
  final int page;

  LoadMbtiQuestions(this.page);
}

class SubmitMbtiAnswers extends MbtiQuestionEvent {
  final int page;
  final List<int> answers;
  final bool isLastPage;

  SubmitMbtiAnswers({
    required this.page,
    required this.answers,
    required this.isLastPage,
  });
}
