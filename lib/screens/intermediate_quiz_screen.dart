import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class IntermediateQuizScreen extends StatefulWidget {
  const IntermediateQuizScreen({super.key});

  @override
  _IntermediateQuizScreenState createState() => _IntermediateQuizScreenState();
}

class _IntermediateQuizScreenState extends State<IntermediateQuizScreen> {
 final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedOption;
  bool showExplanation = false;
  late Timer _timer;
  int _remainingTime = 30; // 30 seconds per question
  final String currentLevel = 'Intermediate';

  final List<Question> questions = [
    Question(
      questionText:
          "What is the typical flight time for most consumer drones with a standard battery?",
      options: ["5-10 minutes", "20-30 minutes", "1-2 hours", "3-4 hours"],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText:
          "In drone terminology, what does the term 'payload' refer to?",
      options: [
        "The maximum weight a drone can carry",
        "The drone's battery life",
        "The drone's speed",
        "The drone's range"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText:
          "Which of the following sensors is commonly used in drones for obstacle avoidance?",
      options: ["LIDAR", "Thermometer", "Barometer", "Hygrometer"],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText:
          "What is the purpose of an Electronic Speed Controller (ESC) in a drone?",
      options: [
        "To control the camera",
        "To regulate the power to the motors",
        "To adjust the flight altitude",
        "To manage the GPS system"
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText:
          "Which drone flight mode allows the drone to automatically hold its altitude?",
      options: ["Manual mode", "Altitude hold mode", "Sport mode", "GPS mode"],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: "What is 'Return to Home' (RTH) in drone technology?",
      options: [
        "A function that lands the drone at the current location",
        "A feature that brings the drone back to the takeoff point",
        "A command to initiate a new flight path",
        "A mode to hover the drone in place"
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText:
          "Which component in a drone system is responsible for data storage and processing?",
      options: ["Transmitter", "Flight controller", "Receiver", "Propeller"],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText:
          "What does the acronym BVLOS stand for in the context of drone operations?",
      options: [
        "Beyond Visual Line of Sight",
        "Basic Visual Light Optimization System",
        "Battery Voltage Level Output System",
        "Balanced Vertical Lift Over System"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText:
          "Which of the following is a common application of drones in agriculture?",
      options: [
        "Livestock tracking",
        "Crop spraying",
        "Soil analysis",
        "Weather forecasting"
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText:
          "In which country is it mandatory to register drones weighing over 250 grams with the aviation authority?",
      options: ["United States", "China", "Canada", "United Kingdom"],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: "What is the function of the GPS module in a drone?",
      options: [
        "To provide power to the drone",
        "To stabilize the drone during flight",
        "To enable precise navigation and positioning",
        "To control the drone's speed"
      ],
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
        if (selectedIndex ==
            questions[currentQuestionIndex].correctAnswerIndex) {
          score += 10; // 10 points for each correct answer
        }
        _timer.cancel(); // Stop the timer once an answer is chosen
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
        checkIfPassed(); // Check if the user passes the quiz
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
        checkIfPassed(); // Check if the user passes the quiz
      }
    });
  }

  void checkIfPassed() async {
  double percentageScore = (score / (questions.length * 10)) * 100;
  User? user = _auth.currentUser;

  if (user != null) {
    String userId = user.uid;

    if (percentageScore >= 70) {
      // Unlock next level (Advanced)
      await _firestore.collection('users').doc(userId).update({
        'advancedUnlocked': true,
      });

      // Save the user's score
      await _firestore.collection('users').doc(userId).update({
        'score': score,
      });

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Quiz Completed!'),
            content: Text('Your score is $score. You passed!'),
            actions: <Widget>[
              TextButton(
                child: const Text('Proceed'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/levels');
                  // Navigate to the next level or home screen
                },
              ),
            ],
          );
        },
      );
    } else {
      // Show failure dialog with option to retry
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Quiz Completed!'),
            content: Text('Your score is $score. You did not pass.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context); // Navigate back to the levels screen
                },
              ),
              TextButton(
                child: const Text('Retake'),
                onPressed: () {
                  Navigator.of(context).pop();
                  resetQuiz(); // Reset the quiz and start over
                },
              ),
            ],
          );
        },
      );
    }
  }
}


  void resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      selectedOption = null;
      showExplanation = false;
      _remainingTime = 30;
      startTimer(); // Restart the timer
    });
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
        title: const Text('Intermediate Quiz'),
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
              ...questions[currentQuestionIndex]
                  .options
                  .asMap()
                  .entries
                  .map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedOption == entry.key
                          ? (selectedOption ==
                                  questions[currentQuestionIndex]
                                      .correctAnswerIndex
                              ? Colors.green
                              : Colors.red)
                          : const Color.fromARGB(255, 230, 230, 230),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: selectedOption == null
                        ? () => answerQuestion(entry.key)
                        : null,
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
                  selectedOption ==
                          questions[currentQuestionIndex].correctAnswerIndex
                      ? 'Correct!'
                      : 'Incorrect.\nThe correct answer was: ${questions[currentQuestionIndex].options[questions[currentQuestionIndex].correctAnswerIndex]}',
                  style: TextStyle(
                    fontSize: 14,
                    color: selectedOption ==
                            questions[currentQuestionIndex].correctAnswerIndex
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Text(
                'Time Remaining: $_remainingTime seconds',
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(foregroundColor: Colors.grey),
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
