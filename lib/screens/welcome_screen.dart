import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
              Image.asset(
                'lib/assets/icon_splash_screen.png',
                width: 200,
                height: 200,
              ),
              const Spacer(),
              _WelcomeButton(
                label: 'Sign in',
                onPressed: () => context.go('/login'),
              ),
              const SizedBox(height: 16),
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

class _WelcomeButton extends StatelessWidget {
  const _WelcomeButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: const Color(0xFF8884FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

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
          left: 24, right: 24, top: 32,
          bottom: 16 + bottomPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Important:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text(
              'Notes are saved locally and cannot be recovered after uninstalling the app.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black87, height: 1.5),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await GuestService.setGuestMode();
                if (context.mounted) context.go('/home');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF8884FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              ),
              child: const Text('Continue', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF8884FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              ),
              child: const Text('Cancel', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    },
  );
}