class SurveyQuestion {
  final String question;
  final List<String> options;
  final int weight;
  String selectedOption;

  SurveyQuestion({
    required this.question,
    required this.options,
    required this.weight,
    this.selectedOption = '',
  });
}
