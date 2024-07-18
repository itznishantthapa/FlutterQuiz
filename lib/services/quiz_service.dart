import 'dart:convert';
import '../models/quiz_model.dart';
import 'package:http/http.dart' as http;

Future<List<QuizQuestion>> fetchQuizQuestions() async {
  final response =
      await http.get(Uri.parse('https://opentdb.com/api.php?amount=20'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final List<QuizQuestion> questions = [];
    final List<dynamic> questionsJson = jsonData['results'];
    for (var questionsJson in questionsJson) {
      questions.add(QuizQuestion.fromJson(questionsJson));
    }
    return questions;
  } else {
    throw Exception('Failed to load the questions');
  }
}
