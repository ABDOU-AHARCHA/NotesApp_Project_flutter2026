import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/guest_service.dart';
import '../../screens/splash_screen.dart';
import '../../screens/welcome_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/signup_screen.dart';
import '../../screens/forget_password_screen.dart';
import '../../screens/home_screen.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((_) {
      notifyListeners();
    });
  }

  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;
}

final AuthNotifier authNotifier = AuthNotifier();

final GoRouter router = GoRouter(
  initialLocation: '/',
  refreshListenable: authNotifier,
  redirect: (context, state) async {
    final isLoggedIn = authNotifier.isLoggedIn;
    final isGuest = await GuestService.isGuestMode();
    final isAuthed = isLoggedIn || isGuest;

    final loc = state.matchedLocation;
    final authRoutes = ['/', '/welcome', '/login', '/signup', '/forgot-password'];
    final onAuthRoute = authRoutes.contains(loc);

    if (isAuthed && onAuthRoute && loc != '/') return '/home';
    if (!isAuthed && !onAuthRoute) return '/welcome';

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgetPasswordScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const NotesHomeScreen(),
    ),
  ],
);