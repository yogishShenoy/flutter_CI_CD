import 'dart:math' as math;

import 'package:flutter/material.dart';

class RepeatingAnimation extends StatelessWidget {
  const RepeatingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: _offsetAnimation()));
  }


  Widget _offsetAnimation()=> RepeatingAnimationBuilder<Offset>(
    repeatMode: RepeatMode.reverse,
    animatable: Tween<Offset>(
        begin: const Offset(0, 0),
        end: const Offset(100, 50)
    ),
    duration: const Duration(seconds: 1),
    builder: (context, offset, child) {
      return Transform.translate(
        offset: offset,
        child: child,
      );
    },
    child: const FlutterLogo(),
  );

  Widget _meshGradient() => RepeatingAnimationBuilder<double>(
    repeatMode: RepeatMode.reverse,
    animatable: Tween(begin: -1.0, end: 1.0),
    duration: const Duration(seconds: 10),
    builder: (context, value, child) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(value, -1.0), // Moves the light source
            end: Alignment(-value, 1.0),
            colors: [
              Color.lerp(Colors.purple, Colors.blue, (value + 1) / 2)!,
              Color.lerp(Colors.blue, Colors.pink, (value + 1) / 2)!,
            ],
          ),
        ),
      );
    },
  );

  Widget _snowfall() =>
      Container(
        color: Colors.black,
        child:
      RepeatingAnimationBuilder<double>(
    animatable: Tween(begin: 0.0, end: 2.5),
    duration: const Duration(seconds: 10),
    builder: (context, value, child) {
      return Stack(
        children: List.generate(10, (index) {
          // Each particle gets a unique horizontal shift based on its index
          double dx = (index * 40.0) + (math.sin(value * 5 + index) * 20);
          double dy = (value * 400) - 50; // Falls from top to bottom

          return Positioned(
            left: dx,
            top: dy,
            child: const Icon(Icons.ac_unit, color: Colors.white, size: 15),
          );
        }),
      );
    },
  ));

  Widget _liquidLoader() => RepeatingAnimationBuilder<double>(
    repeatMode: RepeatMode.reverse,
    animatable: Tween(begin: 0.0, end: 1.0),
    duration: const Duration(seconds: 1),
    curve: Curves.easeInOutBack, // Gives that "overshoot" liquid feel
    builder: (context, value, child) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..scale(1.0 + (value * 0.2), 1.0 - (value * 0.2)) // Squish effect
          ..rotateZ(value * 0.5), // Subtle tilt
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(20 + (value * 30)), // Morph to circle
          ),
        ),
      );
    },
  );

  Widget _blinkingCursor() => RepeatingAnimationBuilder<double>(
    repeatMode: RepeatMode.reverse,
    animatable: Tween(begin: 0.0, end: 1.0),
    duration: const Duration(milliseconds: 500),
    builder: (context, value, child) {
      return Opacity(
        opacity: value > 0.5 ? 1.0 : 0.0, // Hard "on/off" blink
        // For a soft blink, just use 'opacity: value'
        child: Container(
          width: 3,
          height: 24,
          color: Colors.blue,
        ),
      );
    },
  );

  Widget _radarRing() => RepeatingAnimationBuilder<double>(
    animatable: Tween(begin: 0.0, end: 1.0),
    duration: const Duration(seconds: 2),
    builder: (context, value, child) {
      return Container(
        width: 200 * value, // Gets bigger
        height: 200 * value,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.green.withOpacity(1 - value), // Gets transparent
            width: 4 * (1 - value), // Gets thinner
          ),
        ),
      );
    },
  );


  Widget _orbit() => RepeatingAnimationBuilder<double>(
    animatable: Tween(begin: 0.0, end: 2 * math.pi), // 0 to 360 degrees
    duration: const Duration(seconds: 4),
    builder: (context, value, child) {
      double radius = 60.0;
      // Convert polar coordinates to Cartesian (x, y)
      double dx = radius * math.cos(value);
      double dy = radius * math.sin(value);

      return Transform.translate(
        offset: Offset(dx, dy),
        child: child,
      );
    },
    child: const Icon(Icons.public, color: Colors.blue, size: 40),
  );

  Widget _scanner() => RepeatingAnimationBuilder<double>(
  //  reverse: true, // Smoothly returns to the top
    repeatMode: RepeatMode.reverse,
    animatable: Tween(begin: 0.0, end: 200.0), // The height of your container
    duration: const Duration(seconds: 2),
    curve: Curves.linear, // Constant speed for a scanner
    builder: (context, value, child) {
      return Stack(
        children: [
          child!, // The content being "scanned"
          Positioned(
            top: value,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withOpacity(0.8),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
                color: Colors.cyan,
              ),
            ),
          ),
        ],
      );
    },
    child: Container(width: 200, height: 200, color: Colors.black12),
  );

  Widget _shimmer() => RepeatingAnimationBuilder<double>(
    animatable: Tween(begin: -1.0, end: 2.0),
    // Moves the gradient across the axis
    duration: const Duration(milliseconds: 1500),
    builder: (context, value, child) {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!],
            stops: [value - 0.2, value, value + 0.2],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      );
    },
  );

  Widget _rainbowBorder() => RepeatingAnimationBuilder<double>(
    animatable: Tween(begin: 0.0, end: 360.0),
    // Full 360 degrees of the color wheel
    duration: const Duration(seconds: 3),
    builder: (context, value, child) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: HSVColor.fromAHSV(1.0, value, 1.0, 1.0).toColor(),
            width: 4,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("LEVEL UP!"),
        ),
      );
    },
  );

  Widget _floating()=>RepeatingAnimationBuilder<double>(
    repeatMode: RepeatMode.reverse,
    animatable: Tween(begin: 0.0, end: 40.0), // Moves 15 pixels up and down
    duration: const Duration(seconds: 2),
    curve: Curves.easeInOut, // Smooth "wave" motion
    builder: (context, value, child) {
      return Transform.translate(
        offset: Offset(0, value),
        child: child,
      );
    },
    child: const Icon(Icons.cloud, size: 60, color: Colors.blue),
  );


  Widget _coinSpin() => RepeatingAnimationBuilder<double>(
    animatable: Tween(begin: 0.0, end: 2 * math.pi), // 0 to 360 degrees in radians
    duration: const Duration(seconds: 2),
    builder: (context, value, child) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Adds 3D perspective
          ..rotateY(value),       // Flips it horizontally
        child: child,
      );
    },
    child: Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.amber,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text("\$", style: TextStyle(fontSize: 40, color: Colors.white)),
      ),
    ),
  );


  Widget _heartbeat() => RepeatingAnimationBuilder<double>(
    animatable: Tween(begin: 0.0, end: math.pi * 4), // 2 full sine waves
    duration: const Duration(milliseconds: 1200),
    builder: (context, value, child) {
      // Math.sin creates the pumping motion.
      // We use .clamp to create the "pause" between beats.
      double scale = 1.0 + (math.sin(value).clamp(0.0, 1.0) * 0.2);

      return Transform.scale(
        scale: scale,
        child: child,
      );
    },
    child: const Icon(Icons.favorite, size: 60, color: Colors.red),
  );

  Widget _marquee() => ClipRect( // Hides the text when it leaves the box
    child: SizedBox(
      width: 200, // The visible window size
      height: 50,
      child: RepeatingAnimationBuilder<double>(
        animatable: Tween(begin: 200.0, end: -200.0), // Starts on right, moves to left
        duration: const Duration(seconds: 4),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(value, 0), // Moves horizontally
            child: child,
          );
        },
        child: const Center(
          child: Text(
            "BREAKING NEWS: FLUTTER IS AWESOME",
            style: TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        ),
      ),
    ),
  );


  Widget _pendulum() => RepeatingAnimationBuilder<double>(
    repeatMode: RepeatMode.reverse,
    animatable: Tween(begin: -0.5, end: 0.5), // Swing arc (approx -30 to 30 degrees)
    duration: const Duration(seconds: 1),
    curve: Curves.easeInOut, // Slows down at the edges of the swing
    builder: (context, value, child) {
      return Transform.rotate(
        angle: value,
        alignment: Alignment.topCenter, // The pivot point is at the top
        child: child,
      );
    },
    child: Container(
      width: 10,
      height: 100,
      color: Colors.brown,
      alignment: Alignment.bottomCenter,
      child: const CircleAvatar(radius: 20, backgroundColor: Colors.orange),
    ),
  );
}
