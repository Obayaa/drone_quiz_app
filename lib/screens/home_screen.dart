import 'package:flutter/material.dart';
import 'package:drone_quiz_app_updated/widgets/custom_card.dart'; // Update with your actual path

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Navigate to the corresponding screen
      switch (index) {
        case 0:
          Navigator.pushNamed(context, '/home');
          break;
        case 1:
          Navigator.pushNamed(context, '/leaderboard');
          break;
        case 2:
          Navigator.pushNamed(context, '/profile');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Gradient background
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.white, Color.fromARGB(255, 75, 126, 214)],
            center: Alignment.topRight,
            // end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Message
              const Text(
                'Welcome Back, User!',
                style: TextStyle(
                  fontSize: 28, // Increased font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Darker text color
                ),
              ),
              const SizedBox(height: 20),

              // Quick Access Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomCard(
                    icon: Icons.play_arrow,
                    title: 'Start Quiz',
                    onTap: () {
                      Navigator.pushNamed(context, '/levels');
                    },
                    height: 140.0, // Adjusted height
                  ),
                  const SizedBox(width: 16),
                  CustomCard(
                    icon: Icons.leaderboard,
                    title: 'Leaderboard',
                    onTap: () {
                      Navigator.pushNamed(context, '/leaderboard');
                    },
                    height: 140.0, // Adjusted height
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Latest Updates
              const Text(
                'Latest Updates',
                style: TextStyle(
                  fontSize: 22, // Increased font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Darker text color
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey.shade100, offset: Offset(0, 1))], // Shadow effect
                ),
                padding: const EdgeInsets.all(25.0),
                child: const Text(
                  'Check out the new levels added to the quiz! We have exciting challenges waiting for you.',
                  style: TextStyle(fontSize: 16, color: Colors.black87), // Darker text color
                ),
              ),
              const SizedBox(height: 20),

              // Recent Activity
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 22, // Increased font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Darker text color
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey.shade100, offset: Offset(0, 1))], // Shadow effect
                ),
                padding: const EdgeInsets.all(25.0),
                child: const Text(
                  'You completed the Beginner Level 1 quiz with a score of 90%. Great job!',
                  style: TextStyle(fontSize: 16, color: Colors.black87), // Darker text color
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 40), // Larger icon
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard, size: 40), // Larger icon
            label: 'Leaderboard', 
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 40), // Larger icon
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blueAccent, // Highlight color
        unselectedItemColor: Colors.grey, // Unselected color
        showUnselectedLabels: true,
      ),
    );
  }
}
