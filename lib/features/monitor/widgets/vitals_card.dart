import 'package:flutter/material.dart';

class VitalsCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final Color iconColor;
  final IconData icon;

  const VitalsCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
        child: Column(
          spacing: 8,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 2),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.visible,
                ),
              ],
            ),

            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),

            Text(
              unit,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
