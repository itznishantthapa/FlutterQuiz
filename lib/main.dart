import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuizHomePage(),
    );
  }
}

Future<List<dynamic>> loadJson() async {
  String jsonString = await rootBundle.loadString('assets/data.json');
  return json.decode(jsonString)['quiz'];
}

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({super.key});

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  List<dynamic>? _questionsList;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizFinished = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    List<dynamic> questions = await loadJson();
    setState(() {
      _questionsList = questions;
    });
  }

  void _answerQuestion(String answer) {
    if (answer == _questionsList![_currentQuestionIndex]['answer']) {
      _score++;
    }
    setState(() {
      if (_currentQuestionIndex < _questionsList!.length - 1) {
        _currentQuestionIndex++;
      } else {
        _quizFinished = true;
      }
    });
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _quizFinished = false;
    });
  }

  Widget _buildOptionButton(String option) {
    return ElevatedButton(
      onPressed: () {
        _answerQuestion(option);
      },
      child: Text(option),
    );
  }

  List<Widget> _buildOptions() {
    List<Widget> optionButtons = [];
    for (String option in _questionsList![_currentQuestionIndex]['option']) {
      optionButtons.add(_buildOptionButton(option));
      optionButtons.add(SizedBox(height: 10));
    }
    return optionButtons;
  }

  @override
  Widget build(BuildContext context) {
    if (_quizFinished) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Quiz App"),
          centerTitle: true,
          backgroundColor: Colors.yellow,
          elevation: 10,
        ),
        body: Center(
          child: Column(
            children: [
              Text('Your Score: $_score / ${_questionsList!.length}'),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: _restartQuiz, child: Text('Restart Quiz')),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Quiz App"),
          centerTitle: true,
          backgroundColor: Colors.yellow,
          elevation: 10,
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                _questionsList![_currentQuestionIndex]['question'],
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              ..._buildOptions(),
            ],
          ),
        ),
      );
    }
  }
}
