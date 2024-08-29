import 'dart:async';
import 'package:flutter/material.dart';

class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class AdvancedQuizScreen extends StatefulWidget {
  const AdvancedQuizScreen({super.key});

  @override
  _AdvancedQuizScreenState createState() => _AdvancedQuizScreenState();
}

class _AdvancedQuizScreenState extends State<AdvancedQuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedOption;
  bool showExplanation = false;
  late Timer _timer;
  int _remainingTime = 30; // 30 seconds for each question

  final List<Question> questions = [
    Question(
      questionText: "What is the function of the GPS module in a drone?",
      options: ["To provide power to the drone", "To stabilize the drone during flight", "To enable precise navigation and positioning", "To control the drone's speed"],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: "Which type of drone is typically used for inspection of large infrastructures like bridges and wind turbines?",
      options: ["Fixed-wing drones", "Single-rotor helicopters", "Multi-rotor drones", "Blimps"],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: "What is 'geofencing' in the context of drones?",
      options: ["A method for preventing drone theft", "A system that defines the drone's flight boundaries", "A feature that boosts drone speed", "A camera stabilization technique"],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: "Which of the following is a common legal restriction for recreational drone flights in most countries?",
      options: ["Must fly below 400 feet", "Must be equipped with a parachute", "Must be flown indoors", "Must have a pilot license"],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: "What is the primary purpose of a drone's telemetry system?",
      options: ["To control the drone's flight path", "To provide real-time data on the drone's status", "To enhance camera quality", "To increase battery life"],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: "Which technology is used in drones to determine altitude by measuring air pressure?",
      options: ["LIDAR", "GPS", "Barometer", "Sonar"],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: "What is the primary purpose of an FPV (First Person View) system in a drone?",
      options: ["To control the drone via voice commands", "To provide a live video feed from the drone's perspective", "To increase the drone's speed", "To stabilize the drone's flight"],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: "Which component of a drone is responsible for converting electrical energy into mechanical energy?",
      options: ["Battery", "Motor", "ESC", "Propeller"],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: "What does the term 'hovering' mean in drone terminology?",
      options: ["Flying in circles", "Flying at a constant altitude without moving horizontally", "Ascending rapidly", "Descending rapidly"],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: "Which of the following is a benefit of using drones in search and rescue operations?",
      options: ["High cost", "Limited range", "Real-time aerial imagery", "Heavy weight"],
      correctAnswerIndex: 2,
    ),
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _remainingTime = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel();
          skipQuestion();
        }
      });
    });
  }

  void answerQuestion(int selectedIndex) {
    if (selectedOption == null) {
      setState(() {
        selectedOption = selectedIndex;
        showExplanation = true;
        if (selectedIndex == questions[currentQuestionIndex].correctAnswerIndex) {
          score++;
        }
        _timer.cancel();
      });
    }
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        selectedOption = null;
        showExplanation = false;
        _remainingTime = 30;
        startTimer();
      } else {
        showResults();
      }
    });
  }

  void skipQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        selectedOption = null;
        showExplanation = false;
        _remainingTime = 30;
        startTimer();
      } else {
        showResults();
      }
    });
  }

  void showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quiz Completed!'),
          content: Text('Your score is $score out of ${questions.length}'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); 
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Advanced Quiz'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent.shade700,
        automaticallyImplyLeading: false, 
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildProgressIndicator(),
              const SizedBox(height: 10),
              Text(
                'Question ${currentQuestionIndex + 1} of ${questions.length}',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 16),
              Text(
                questions[currentQuestionIndex].questionText,
                style: const TextStyle(fontSize: 19, color: Colors.black),
              ),
              const SizedBox(height: 16),
              ...questions[currentQuestionIndex].options.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedOption == entry.key
                          ? (selectedOption == questions[currentQuestionIndex].correctAnswerIndex ? Colors.green : Colors.red)
                          : const Color.fromARGB(255, 230, 230, 230),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: selectedOption == null ? () => answerQuestion(entry.key) : null, // Disable all buttons if an option has been selected
                    child: Text(
                      entry.value,
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                );
              }).toList(),
              if (showExplanation) ...[
                const SizedBox(height: 17),
                Text(
                  selectedOption == questions[currentQuestionIndex].correctAnswerIndex
                      ? 'Correct!'
                      : 'Incorrect.\nThe correct answer was: ${questions[currentQuestionIndex].options[questions[currentQuestionIndex].correctAnswerIndex]}',
                  style: TextStyle(
                    fontSize: 14,
                    color: selectedOption == questions[currentQuestionIndex].correctAnswerIndex ? Colors.green : Colors.red,
                  ),
                ),
                if (selectedOption != questions[currentQuestionIndex].correctAnswerIndex)
                  Text(
                    'Explanation: The correct answer is ${questions[currentQuestionIndex].options[questions[currentQuestionIndex].correctAnswerIndex]} because it is the widely accepted definition or characteristic.',
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                  ),
              ],
              const SizedBox(height: 16),
              Text(
                'Time Remaining: $_remainingTime seconds',
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(foregroundColor: Colors.grey),
                    onPressed: skipQuestion,
                    child: const Text('Skip'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent.shade700,
                    ),
                    onPressed: selectedOption != null ? nextQuestion : null,
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProgressIndicator() {
    return LinearProgressIndicator(
      value: (currentQuestionIndex + 1) / questions.length,
      backgroundColor: Colors.grey[200],
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
    );
  }
}
