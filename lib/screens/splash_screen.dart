import 'package:flutter/material.dart';
import 'auth_gate.dart';
import 'home_screen.dart';
import 'welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/guest_service.dart'; // add this import at top

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToWelcome();
  }

  Future<void> _navigateToWelcome() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check 1: Is user logged in with Firebase?
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NotesHomeScreen()),
      );
      return;
    }

    // Check 2: Did user previously choose Guest?
    final isGuest = await GuestService.isGuestMode();
    if (isGuest) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NotesHomeScreen()),
      );
      return;
    }

    // Neither — show Welcome Screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7BCE8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── App Name ──
            const Text(
              'Memoa',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 12),

            // ── Icon ──
            Image.asset(
              'lib/assets/icon_splash_screen.png',
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}