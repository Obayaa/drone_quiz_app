import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252), // Faint white background
      appBar: AppBar(
        title: const Text('Profile'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent, // AppBar color
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      // Profile Header
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _user!.photoURL != null
                            ? NetworkImage(_user!.photoURL!)
                            : const AssetImage('images/welcome_background.jpg') as ImageProvider,
                        backgroundColor: Colors.grey[200], // Background color of the profile picture
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        _user!.displayName ?? 'User',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        _user!.email ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 15.0),
                      
                      // Profile Information Card
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Full Name: ${_user!.displayName ?? 'N/A'}'),
                          const SizedBox(height: 8.0),
                          Text('Email: ${_user!.email ?? 'N/A'}'),
                          const SizedBox(height: 8.0),
                          // Add more user details here if needed
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      
                      // Edit Profile Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/editProfile');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white, // Button color
                          padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 12.0),
                        ),
                        child: const Text('Edit Profile'),
                      ),
                      const SizedBox(height: 16.0),
                                  
                      // Change Password Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/changePassword');
                        },
                        style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.blue,
                          foregroundColor: Colors.white, // Button color
                          padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 12.0),
                        ),
                        child: const Text('Change Password'),
                      ),
                      const SizedBox(height: 16.0),
                                  
                      // Logout Button
                      ElevatedButton(
                        onPressed: () async {
                          await _auth.signOut();
                          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.red,
                          foregroundColor: Colors.white, // Button color
                          padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 12.0),
                        ),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
