import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drone_quiz_app_updated/screens/advanced_quiz_screen.dart';
import 'package:drone_quiz_app_updated/screens/beginner_quiz_screen.dart';
import 'package:drone_quiz_app_updated/screens/intermediate_quiz_screen.dart';
import 'package:drone_quiz_app_updated/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/registration_screen.dart';
import 'auth/login_screen.dart';
import 'auth/forgot_password_screen.dart';
import 'screens/levels_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'auth/change_password_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/levels': (context) => const LevelsScreen(),
        '/quiz': (context) => QuizScreen(),
        '/result': (context) => ResultScreen(),
        '/forgotPassword': (context) => const ForgotPasswordScreen(),
        '/profile': (context) => ProfileScreen(),
        '/editProfile': (context) => EditProfileScreen(),
        '/changePassword': (context) => const ChangePasswordScreen(),
        '/leaderboard': (context) =>
            LeaderboardScreen(), // Add LeaderboardScreen route
        '/home': (context) => HomeScreen(), // Add HomeScreen route
        '/loading': (context) => const LoadingScreen(),
        '/intermediateQuiz': (context) => const IntermediateQuizScreen(),
        '/beginnerQuiz': (context) => const BeginnerQuizScreen(),
        'advanceQuiz': (context) => const AdvancedQuizScreen()
      },
    );
  }
}
