// lib/widgets/custom_card.dart
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final double height;
  final double width;
  final double iconSize;
  final double textSize;

  const CustomCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.height = 150.0, // Default height of the card
    this.width = 170.0,
    this.iconSize = 50.0, // Default size of the icon
    this.textSize = 20.0, // Default size of the text
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, // Moderate shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      color: Colors.white, // Card color
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height, // Set height of the card
          width: width,
          padding: const EdgeInsets.all(16.0), // Padding inside the card
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.blue, size: iconSize), // Consistent icon color
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Consistent text color
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
