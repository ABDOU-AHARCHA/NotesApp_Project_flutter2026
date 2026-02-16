import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart'; // adjust import path as needed

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;
  late Animation<double> _iconScale;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeIn = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _iconScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7BCE8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),

              // ── Title ──
              FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _slideUp,
                  child: const Text(
                    'Welcome To\nMemoa',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // ── App Icon ──
              ScaleTransition(
                scale: _iconScale,
                child: Image.asset(
                  'assets/icon_splash_screen.png',
                  width: 200,
                  height: 200,
                ),
              ),

              const Spacer(),

              // ── Sign In Button ──
              FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.4),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
                  )),
                  child: _WelcomeButton(
                    label: 'Sign in',
                    backgroundColor: const Color(0xFFB8AAEE),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen()),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Continue as Guest Button ──
              FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                  )),
                  child: _WelcomeButton(
                    label: 'Continue as Guest',
                    backgroundColor: const Color(0xFF8884FF),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const NotesHomeScreen()),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

/// ── Reusable rounded button ──────────────────────────────────────────────────
class _WelcomeButton extends StatelessWidget {
  const _WelcomeButton({
    required this.label,
    required this.backgroundColor,
    required this.onPressed,
  });

  final String label;
  final Color backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 4,
          shadowColor: backgroundColor.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}