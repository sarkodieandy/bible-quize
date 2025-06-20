import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, '/home');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.book, size: 100, color: Color(0xFF3E5F8A))
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: -0.5, curve: Curves.easeOut)
                  .then() // next animation
                  .shake(), // subtle shake for effect

              const SizedBox(height: 20),

              const Text(
                    'The Word',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 47, 33, 170),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 400.ms)
                  .slideY(begin: 0.5, curve: Curves.easeOut)
                  .then()
                  .scaleXY(
                    end: 1.1,
                    duration: 400.ms,
                    curve: Curves.elasticOut,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
