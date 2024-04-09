import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class CompassPage extends StatefulWidget {
  @override
  _CompassPageState createState() => _CompassPageState();
}

class _CompassPageState extends State<CompassPage> {
  double _heading = 0.0;
  late StreamSubscription<MagnetometerEvent> _magnetometerSubscription;

  @override
  void initState() {
    super.initState();
    // Initialize the magnetometer sensor subscription
    _startListeningToMagnetometer();
  }

  @override
  void dispose() {
    // Cancel the subscription when the widget is disposed
    _magnetometerSubscription.cancel();
    super.dispose();
  }

  void _startListeningToMagnetometer() {
    _magnetometerSubscription =
        magnetometerEvents.listen((MagnetometerEvent event) {
      // Calculate the heading based on magnetometer data
      double heading = math.atan2(event.y, event.x);
      setState(() {
        _heading = heading;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.hintColor,
        title: Text(
          'Compass',
          style: TextStyle(color: theme.primaryColor),
        ),
        iconTheme: IconThemeData(
          color: theme.primaryColor, // This sets the back arrow color
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              size: Size(300, 300),
              painter: CompassPainter(heading: _heading),
              child: Container(
                width: 200,
                height: 200,
                child: Transform.rotate(
                  angle: -_heading - math.pi / 2,
                  child: Image.asset(
                    'lib/assets/compass-arrow-navigation.png',
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ),
            SizedBox(height: 90),
            Text(
              'Heading: ${(_heading * 180 / math.pi).toStringAsFixed(2)}°',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class CompassPainter extends CustomPainter {
  final double heading;

  CompassPainter({required this.heading});

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2;

    // Define compass point labels
    final List<String> points = ['E', 'NE', 'N', 'NW', 'W', 'SW', 'S', 'SE'];

    // Increase the spacing between compass points and center
    final double textOffset = 40.0;

    // Define text style for normal points
    final TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 20.0);

    // Define text style for the bold point
    final TextStyle boldTextStyle = TextStyle(
        color: Colors.red, fontSize: 25.0, fontWeight: FontWeight.bold);

    // Determine the sector size
    final double sectorSize = 2 * math.pi / points.length;

    // Calculate the normalized heading between 0 and 2*pi
    double normalizedHeading = heading % (2 * math.pi);
    if (normalizedHeading < 0) {
      normalizedHeading += 2 * math.pi;
    }

    // Determine the sector index where the arrow is pointing
    int arrowSectorIndex =
        ((normalizedHeading + math.pi / 8) / sectorSize).floor() %
            points.length;

    // Loop through each compass point and draw lines and text
    for (int i = 0; i < points.length; i++) {
      final double angle = (2 * math.pi / points.length) * i;
      final double textX = centerX + math.cos(angle) * (radius + textOffset);
      final double textY = centerY - math.sin(angle) * (radius + textOffset);

      // Draw lines
      final double lineX = centerX + math.cos(angle) * radius;
      final double lineY = centerY - math.sin(angle) * radius;

      canvas.drawLine(Offset(centerX, centerY), Offset(lineX, lineY),
          Paint()..color = Colors.black);

      // Determine if the point should be bold
      bool isBold = arrowSectorIndex == i;

      // Draw text with appropriate style
      TextSpan span =
          TextSpan(style: isBold ? boldTextStyle : textStyle, text: points[i]);
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(textX - tp.width / 2, textY - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
