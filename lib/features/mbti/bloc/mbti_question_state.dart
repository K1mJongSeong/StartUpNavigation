import '../domain/entities/mbti_question.dart';

abstract class MbtiQuestionState {}

class MbtiInitial extends MbtiQuestionState {}

class MbtiLoading extends MbtiQuestionState {}

class MbtiLoaded extends MbtiQuestionState {
  final List<MbtiQuestion> questions;
  final int currentPage;
  final int totalPages;

  MbtiLoaded({
    required this.questions,
    required this.currentPage,
    required this.totalPages,
  });
}

class MbtiError extends MbtiQuestionState {
  final String message;

  MbtiError(this.message);
}

class MbtiSubmitted extends MbtiQuestionState {}