import 'package:flutter/material.dart';
import 'beginner_quiz_screen.dart';
import 'intermediate_quiz_screen.dart';
import 'advanced_quiz_screen.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text('Levels'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Select your preferred level to start the quiz. Each level is designed to challenge you and improve your knowledge.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView(
                children: [
                  LevelCard(
                    level: 'Beginner',
                    color: Colors.lightBlueAccent,
                    targetScreen: const BeginnerQuizScreen(),
                  ),
                  LevelCard(
                    level: 'Intermediate',
                    color: Colors.orangeAccent,
                    targetScreen: const IntermediateQuizScreen(),
                  ),
                  LevelCard(
                    level: 'Advanced',
                    color: Colors.greenAccent,
                    targetScreen: const AdvancedQuizScreen(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LevelCard extends StatelessWidget {
  final String level;
  final Color color;
  final Widget targetScreen;

  LevelCard({
    required this.level,
    required this.color,
    required this.targetScreen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        color: color,
        child: Container(
          height: 100.0, // Adjust the height as needed
          alignment: Alignment.center,
          child: Center(
            child: Text(
              level,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors
                    .white, // Ensures text is visible on colored background
              ),
            ),
          ),
        ),
      ),
    );
  }
}
