import 'dart:math';

import 'package:flutter/material.dart';

import 'dailyUpdateForm.dart';
import 'loginScreen.dart';

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Profile'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Home') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              } else if (value == 'Daily Updates') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExpandableCardFormApp()),
                );
              } else if (value == 'Logout') {
                _logout(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return {
                'Home',
                'Daily Updates',
                'About Us',
                'Contact Us',
                'Logout'
              }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              radius: 50.0,
              backgroundImage: NetworkImage(
                  'https://cdn.pixabay.com/photo/2015/10/05/22/39/profile-973560_960_720.jpg'),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'john.doe@example.com',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Handle edit profile button press
              },
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        "Activity Graph",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: CustomPaint(
                          size: const Size(double.infinity, 200),
                          painter: ActivityGraphPainter(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    print('Logged out');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const Loginscreen()),
    );
  }
}

class ActivityGraphPainter extends CustomPainter {
  final List<double> dataPoints = [1, 3, 2, 4, 3, 5];

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final Paint pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final Paint gridPaint = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final double spacingX = size.width / (dataPoints.length - 1);
    final double maxY = dataPoints.reduce(max);
    final double scaleY = size.height / maxY;

    for (double i = 0; i <= maxY; i++) {
      double y = size.height - (i * scaleY);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    Path linePath = Path();
    for (int i = 0; i < dataPoints.length; i++) {
      double x = i * spacingX;
      double y = size.height - (dataPoints[i] * scaleY);

      if (i == 0) {
        linePath.moveTo(x, y);
      } else {
        linePath.lineTo(x, y);
      }

      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }

    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
