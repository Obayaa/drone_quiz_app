import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'beginner_quiz_screen.dart';
import 'intermediate_quiz_screen.dart';
import 'advanced_quiz_screen.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({super.key});

  @override
  _LevelsScreenState createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  bool _isIntermediateUnlocked = false;
  bool _isAdvancedUnlocked = false;
  int _userScore = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadUserProgress();
  }

  Future<void> _loadUserProgress() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;
        setState(() {
          _isIntermediateUnlocked = userData?['intermediateUnlocked'] ?? false;
          _isAdvancedUnlocked = userData?['advancedUnlocked'] ?? false;
          _userScore = userData?['score'] ?? 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Levels'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed('/home'); // Navigate to home screen
          },
        ),
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
                  const LevelCard(
                    level: 'Beginner',
                    color: Colors.lightBlueAccent,
                    targetScreen: BeginnerQuizScreen(),
                    isEnabled: true,
                  ),
                  LevelCard(
                    level: 'Intermediate',
                    color: Colors.orangeAccent,
                    targetScreen: const IntermediateQuizScreen(),
                    isEnabled: _isIntermediateUnlocked,
                  ),
                  LevelCard(
                    level: 'Advanced',
                    color: Colors.greenAccent,
                    targetScreen: const AdvancedQuizScreen(),
                    isEnabled: _isAdvancedUnlocked,
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
  final bool isEnabled;

  const LevelCard({
    required this.level,
    required this.color,
    required this.targetScreen,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => targetScreen),
              );
            }
          : null, // Disable tap if level is locked
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5, // Dim card if level is locked
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
      ),
    );
  }
}
