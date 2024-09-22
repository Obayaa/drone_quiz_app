import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _selectedLevel = 0;
  final List<String> levels = ['Beginner', 'Intermediate', 'Advanced'];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
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
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .where('level', isEqualTo: _selectedLevel + 1)
                  .orderBy('score', descending: true)
                  .limit(10)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  if (snapshot.error.toString().contains('indexes')) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Initializing leaderboard...'),
                          SizedBox(height: 10),
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text('This may take a few minutes.'),
                        ],
                      ),
                    );
                  }
                  return const Center(
                      child:
                          Text('An error occurred. Please try again later.'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text(
                          'No data available for ${levels[_selectedLevel]}'));
                }

                final users = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final userData =
                        users[index].data() as Map<String, dynamic>;
                    final rank = index + 1;
                    final username = userData['name'] ?? 'Anonymous';
                    final score = userData['score'] ?? 0;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getRankColor(rank),
                          child: Text(
                            rank.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(username),
                        trailing: Text(score.toString()),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.yellow[700]!;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.brown[300]!;
      default:
        return Colors.blue;
    }
  }
}
