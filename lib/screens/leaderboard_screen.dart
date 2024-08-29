import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _selectedLevel = 0;
  final List<String> levels = ['Beginner', 'Intermediate', 'Advanced'];

  // Mock data
  final Map<int, List<Map<String, dynamic>>> leaderboardData = {
    0: [
      {'rank': 1, 'username': 'UserA', 'score': 90},
      {'rank': 2, 'username': 'UserB', 'score': 85},
      {'rank': 3, 'username': 'UserC', 'score': 80},
    ],
    1: [
      {'rank': 1, 'username': 'UserD', 'score': 95},
      {'rank': 2, 'username': 'UserE', 'score': 90},
      {'rank': 3, 'username': 'UserF', 'score': 85},
    ],
    2: [
      {'rank': 1, 'username': 'UserG', 'score': 100},
      {'rank': 2, 'username': 'UserH', 'score': 95},
      {'rank': 3, 'username': 'UserI', 'score': 90},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: Column(
        children: [
          // Horizontal Slide Buttons
          Container(
            height: 60.0,
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: levels.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedLevel == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedLevel = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Center(
                      child: Text(
                        levels[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Leaderboard List
          Expanded(
            child: ListView.builder(
              itemCount: leaderboardData[_selectedLevel]!.length,
              itemBuilder: (context, index) {
                final data = leaderboardData[_selectedLevel]![index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(data['rank'].toString()),
                    ),
                    title: Text(data['username']),
                    trailing: Text(data['score'].toString()),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
