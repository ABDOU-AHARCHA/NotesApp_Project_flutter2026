
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/screens/welcome_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    print('🚪 AuthGate - Building');
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print('🔍 AuthGate - ConnectionState: ${snapshot.connectionState}');
        print('🔍 AuthGate - HasData: ${snapshot.hasData}');
        print('🔍 AuthGate - User: ${snapshot.data?.email ?? 'null'}');

        // Show loading only on the very first check
        if (snapshot.connectionState == ConnectionState.active) {
          // User is logged in
          if (snapshot.hasData) {
            print('✅ AuthGate - Showing NotesHomeScreen');
            return const NotesHomeScreen();
          }
          // User is NOT logged in
          else {
            print('❌ AuthGate - Showing LoginScreen');
            return const NotesHomeScreen();
          }
        }

        // Show loading indicator only while waiting for initial connection
        print('⏳ AuthGate - Showing Loading...');
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}