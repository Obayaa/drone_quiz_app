import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _confirmPasswordVisible = false;
  }

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (passwordController.text != confirmPasswordController.text) {
        _showAlertDialog('Error', 'Passwords do not match');
        return;
      }
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        if (userCredential.user != null) {
          // Save user details (name, level, score) in Firestore
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'name': nameController.text.trim(), // Store the user's name
            'email': emailController.text.trim(),
            'level': 1, // Default level for new users
            'score': 0, // Default score for new users
          });

          _showSnackbar('Successfully signed up to SkyQuiz!');
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushNamed(context, '/home');
          });
        }
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'email-already-in-use':
            message = 'This email address is already in use.';
            break;
          case 'invalid-email':
            message = 'This email address is not valid.';
            break;
          case 'weak-password':
            message = 'The password is too weak.';
            break;
          default:
            message = 'Registration failed. Please try again.';
        }
        _showAlertDialog('Registration Failed', message);
      } catch (e) {
        print('Error during registration: $e');
        _showAlertDialog('Registration Failed', 'An error occurred: $e');
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          leading: const BackButton(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Register',
                  style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Create an account to get started',
                  style: TextStyle(fontSize: 16.0, color: Colors.black54),
                ),
                const SizedBox(height: 20.0),
                _buildTextField(
                  controller: nameController,
                  hintText: 'Enter your name',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 20.0),
                _buildTextField(
                  controller: emailController,
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                _buildTextField(
                  controller: passwordController,
                  hintText: 'Enter your password',
                  obscureText: !_passwordVisible,
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter your password'
                      : null,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                _buildTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm your password',
                  obscureText: !_confirmPasswordVisible,
                  validator: (value) => value != passwordController.text
                      ? 'Passwords do not match'
                      : null,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: const Size(250, 50),
                  ),
                  child: const Text('Register'),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Already have an account?',
                  style: TextStyle(fontSize: 16.0, color: Colors.black54),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.blue, fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
    Widget? suffixIcon,
  }) {
    return Material(
      elevation: 4.0,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(10.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          suffixIcon: suffixIcon,
        ),
        validator: validator,
      ),
    );
  }
}
