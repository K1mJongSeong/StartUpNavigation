class MbtiQuestion {
  final int idx;
  final String text;
  final String category;
  final double weight;
  final int? selectedScore;

  MbtiQuestion({
    required this.idx,
    required this.text,
    required this.category,
    required this.weight,
    this.selectedScore,
  });
}
