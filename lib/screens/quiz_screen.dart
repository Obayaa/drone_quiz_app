import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  final List<Map<String, Object>> _questions = [
    {
      'question': 'What is the capital of France?',
      'answers': ['Berlin', 'Madrid', 'Paris', 'Rome'],
      'correctAnswer': 'Paris'
    },
    // Add more questions here
  ];

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        Navigator.pushNamed(context, '/result');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex]['question'] as String;
    final answers = _questions[_currentQuestionIndex]['answers'] as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              question,
              style: const TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 20.0),
            ...answers.map((answer) {
              return ElevatedButton(
                onPressed: () {
                  // Add answer checking logic here
                  _nextQuestion();
                },
                child: Text(answer),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
