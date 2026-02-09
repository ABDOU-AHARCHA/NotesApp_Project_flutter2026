// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'login_screen.dart';
// import 'home_screen.dart';
//
// class AuthGate extends StatelessWidget {
//   const AuthGate({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         // User is logged in
//         if (snapshot.hasData) {
//           return const NotesHomeScreen();
//         }
//
//         // Show a loading indicator while we're waiting for the initial state
//         if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//                 body: Center(child: CircularProgressIndicator()),
//             );
//
//         }
//
//         // User is not logged in
//         return const LoginScreen();
//       },
//     );
//   }
// }













import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
            return const LoginScreen();
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