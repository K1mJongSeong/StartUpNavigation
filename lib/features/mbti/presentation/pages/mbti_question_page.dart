import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_navigation/features/mbti/mbti_storage_service.dart';


import '../../bloc/mbti_question_bloc.dart';
import '../../bloc/mbti_question_event.dart';
import '../../bloc/mbti_question_state.dart';
import '../../domain/entities/mbti_question.dart';

class MbtiQuestionPage extends StatefulWidget {
  const MbtiQuestionPage({super.key});

  @override
  State<MbtiQuestionPage> createState() => _MbtiQuestionPageState();
}

class _MbtiQuestionPageState extends State<MbtiQuestionPage> {
  final Map<int, int> _answers = {};

  @override
  void initState() {
    super.initState();
    context.read<MbtiQuestionBloc>().add(LoadMbtiQuestions(1));
  }

  void _onAnswerSelected(int questionIdx, int score) {
    setState(() {
      _answers[questionIdx] = score;
    });
  }

  void _onNextPressed(List<MbtiQuestion> questions, int currentPage, int totalPages) async {
    final isAllAnswered = questions.every((q) => _answers[q.idx] != null);

    if (!isAllAnswered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 문항에 응답해 주세요.')),
      );
      return;
    }

    final formattedAnswers = questions.map((q) => {
      'question_idx': q.idx,
      'score': _answers[q.idx]
    }).toList();

    await MbtiStorageService.savePageAnswers(currentPage, formattedAnswers);

    context.read<MbtiQuestionBloc>().add(
      SubmitMbtiAnswers(page: currentPage, answers: _answers.values.toList(), isLastPage: currentPage == totalPages,)
    );
    // final answers = questions.map((q) => _answers[q.idx]!).toList();
    //
    // context.read<MbtiQuestionBloc>().add(
    //   SubmitMbtiAnswers(
    //     page: currentPage,
    //     answers: answers,
    //     isLastPage: currentPage == totalPages,
    //   ),
    // );
  }

  Widget _buildQuestion(MbtiQuestion q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${q.idx}. ${q.text}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: List.generate(5, (index) {
            final score = index + 1;
            return ChoiceChip(
              label: Text('$score점'),
              selected: _answers[q.idx] == score,
              onSelected: (_) => _onAnswerSelected(q.idx, score),
            );
          }),
        ),
        const Divider(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MBTI 테스트')),
      body: BlocBuilder<MbtiQuestionBloc, MbtiQuestionState>(
        builder: (context, state) {
          if (state is MbtiLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MbtiError) {
            return Center(child: Text(state.message));
          }

          if (state is MbtiLoaded) {
            final questions = state.questions;

            // 최초 진입 시 selectedScore로 상태 초기화
            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //   for (var q in questions) {
            //     if (q.selectedScore != null && !_answers.containsKey(q.idx)) {
            //       _answers[q.idx] = q.selectedScore!;
            //     }
            //   }
            // });

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('페이지 ${state.currentPage} / ${state.totalPages}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: questions.map(_buildQuestion).toList(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        _onNextPressed(questions, state.currentPage, state.totalPages),
                    child: Text(state.currentPage == state.totalPages ? '제출하기' : '다음 페이지'),
                  )
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
