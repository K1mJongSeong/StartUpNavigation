import 'package:bloc/bloc.dart';

import '../domain/usecases/fetch_questions_usecase.dart';
import 'mbti_question_event.dart';
import 'mbti_question_state.dart';

class MbtiQuestionBloc extends Bloc<MbtiQuestionEvent, MbtiQuestionState> {
  final FetchMbtiQuestionsUseCase fetchQuestionsUseCase;

  MbtiQuestionBloc(this.fetchQuestionsUseCase) : super(MbtiInitial()) {
    on<LoadMbtiQuestions>(_onLoadQuestions);
    on<SubmitMbtiAnswers>(_onSubmitAnswers);
  }

  Future<void> _onLoadQuestions(
      LoadMbtiQuestions event,
      Emitter<MbtiQuestionState> emit,
      ) async {
    emit(MbtiLoading());

    try {
      final questions = await fetchQuestionsUseCase(event.page);
      emit(MbtiLoaded(
        questions: questions,
        currentPage: event.page,
        totalPages: 10,
      ));
    } catch (_) {
      emit(MbtiError('질문을 불러오는 데 실패했습니다.'));
    }
  }

  Future<void> _onSubmitAnswers(
      SubmitMbtiAnswers event,
      Emitter<MbtiQuestionState> emit,
      ) async {
    try {
      if(event.isLastPage){
        emit(MbtiSubmitted());
      } else {
        final nextPage = event.page + 1;
        final questions = await fetchQuestionsUseCase(nextPage);
        emit(MbtiLoaded(questions: questions, currentPage: nextPage, totalPages: 10));
      }
    } catch (_) {
      emit(MbtiError('다음 페이지를 불러오는 데 실패했습니다.'));
    }
  }
}
