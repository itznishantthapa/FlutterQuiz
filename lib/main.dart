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
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
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
  bool _quizStarted = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _isLoading = true;
    });
    List<dynamic> questions = await loadJson();
    setState(() {
      _questionsList = questions;
      _isLoading = false;
    });
  }

  void _startQuiz() {
    setState(() {
      _quizStarted = true;
    });
    _loadQuestions();
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
      _quizStarted = false;
    });
  }

  Widget _buildOptionButton(String option) {
    return ElevatedButton(
      onPressed: () {
        _answerQuestion(option);
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        textStyle: TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz App"),
        centerTitle: true,
      ),
      body: Center(
        child: _quizStarted
            ? _isLoading
                ? CircularProgressIndicator()
                : _quizFinished
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Your Score: $_score / ${_questionsList!.length}',
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _restartQuiz,
                            child: Text('Restart Quiz'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 30.0),
                              textStyle: TextStyle(fontSize: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _questionsList![_currentQuestionIndex]['question'],
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ..._buildOptions(),
                        ],
                      )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to the Quiz App!',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _startQuiz,
                    child: Text('Start Quiz'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                      textStyle: TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
