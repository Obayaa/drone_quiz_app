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

class BeginnerQuizScreen extends StatefulWidget {
  const BeginnerQuizScreen({super.key});

  @override
  _BeginnerQuizScreenState createState() => _BeginnerQuizScreenState();
}

class _BeginnerQuizScreenState extends State<BeginnerQuizScreen> {
final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int currentQuestionIndex = 0;
  static const String currentLevel = 'Beginner';
  int score = 0;
  int? selectedOption;
  bool showExplanation = false;
  late Timer _timer;
  int _remainingTime = 30;

  final List<Question> questions = [
    Question(
      questionText: "What is a drone?",
      options: [
        "A type of airplane",
        "An unmanned aerial vehicle (UAV)",
        "A type of helicopter",
        "A spacecraft"
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText:
          "Which of the following components is essential for a drone to function?",
      options: ["Propellers", "Landing gear", "Solar panels", "Tires"],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: "What is the primary purpose of a gimbal on a drone?",
      options: [
        "To provide lift",
        "To stabilize the camera",
        "To control flight direction",
        "To increase speed"
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText:
          "Which technology is commonly used for drone navigation and positioning?",
      options: ["Wi-Fi", "GPS", "Infrared", "Bluetooth"],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText:
          "What is the term for a drone's maximum distance from the controller?",
      options: [
        "Flight altitude",
        "Flight duration",
        "Range",
        "Payload capacity"
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText:
          "What is the term for a drone's ability to hover in a stable position?",
      options: ["Stability", "Loitering", "Hovering", "Position hold"],
      correctAnswerIndex: 3,
    ),
    Question(
      questionText: "Which of the following is a common use of drones?",
      options: [
        "Personal transport",
        "Aerial photography",
        "Underground exploration",
        "Deep-sea diving"
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: "What does FPV stand for in drone technology?",
      options: [
        "First Person View",
        "Fast Propeller Velocity",
        "Fixed Propeller Vehicle",
        "Flight Path Visualization"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText:
          "What type of drone is often used for long-range deliveries?",
      options: [
        "Quadcopters",
        "Fixed-wing drones",
        "Hexacopters",
        "Octocopters"
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText:
          "Which factor is most important for a drone's flight stability?",
      options: [
        "Camera resolution",
        "Battery size",
        "Propeller size",
        "Center of gravity"
      ],
      correctAnswerIndex: 3,
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
        _timer.cancel(); // Stop the timer when an answer is chosen
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
        checkIfPassed();
      }
    });
  }

  void skipQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        selectedOption = null;
        showExplanation = false;
        score += 0;
        _remainingTime = 30;
        startTimer();
      } else {
        checkIfPassed();
      }
    });
  }

  void checkIfPassed() async {
    double percentageScore = (score / (questions.length * 10)) * 100;
    User? user = _auth.currentUser;

    if (user != null) {
      String userId = user.uid;

      if (percentageScore >= 70) {
        if (currentLevel == 'Beginner') {
          await _firestore.collection('users').doc(userId).update({
            'intermediateUnlocked': true, // Unlock intermediate level
          });
        } else if (currentLevel == 'Intermediate') {
          await _firestore.collection('users').doc(userId).update({
            'advancedUnlocked': true, // Unlock advanced level
          });
        }

        // Save the user's score
        await _firestore.collection('users').doc(userId).update({
          'score': score,
        });

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
                    // Navigate to next screen or level selection
                  },
                ),
              ],
            );
          },
        );
      } else {
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
                    Navigator.pop(
                        context); // Navigate back to the levels screen
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
        title: const Text('Beginner Quiz'),
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
