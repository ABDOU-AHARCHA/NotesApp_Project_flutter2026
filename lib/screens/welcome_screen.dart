import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import '../services/guest_service.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
              const Text(
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

              const Spacer(),

              // ── App Icon ──
              Image.asset(
                'lib/assets/icon_splash_screen.png',
                width: 200,
                height: 200,
              ),

              const Spacer(),

              // ── Sign In Button ──
              _WelcomeButton(
                label: 'Sign in',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              ),

              const SizedBox(height: 16),

              // ── Continue as Guest Button ──
              _WelcomeButton(
                label: 'Continue as Guest',
                onPressed: () => _showGuestModeAlert(context),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Unified button matching Login Screen style exactly ──
class _WelcomeButton extends StatelessWidget {
  const _WelcomeButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50), // ✅ matches login
          backgroundColor: const Color(0xFF8884FF),     // ✅ matches login
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),  // ✅ matches login
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,                               // ✅ matches login
            color: Colors.black,                        // ✅ matches login
            fontWeight: FontWeight.bold,                // ✅ matches login
          ),
        ),
      ),
    );
  }
}

// ── Bottom sheet with system nav bar fix + matched button styles ──
void _showGuestModeAlert(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (context) {
      final double bottomPadding = MediaQuery.of(context).viewPadding.bottom;

      return Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5E6F5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 32,
          bottom: 16 + bottomPadding, // ✅ system nav bar fix
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Important:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Notes are saved locally and cannot be recovered after uninstalling the app.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black87, height: 1.5),
            ),
            const SizedBox(height: 32),

            // ── Continue button — matched to login style ──
            ElevatedButton(
              onPressed: () async {
                await GuestService.setGuestMode();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const NotesHomeScreen()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50), // ✅ matches login
                backgroundColor: const Color(0xFF8884FF),     // ✅ matches login
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),  // ✅ matches login
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,                               // ✅ matches login
                  color: Colors.black,                        // ✅ matches login
                  fontWeight: FontWeight.bold,                // ✅ matches login
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Cancel button — matched to login style ──
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50), // ✅ matches login
                backgroundColor: const Color(0xFF8884FF),     // ✅ matches login
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),  // ✅ matches login
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,                               // ✅ matches login
                  color: Colors.black,                        // ✅ matches login
                  fontWeight: FontWeight.bold,                // ✅ matches login
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}