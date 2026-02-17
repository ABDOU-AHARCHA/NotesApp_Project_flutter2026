import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7BCE8),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            const Text(
              'Create Account',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 60),
            Container(
              child: signupForm(),
            ),
            const SizedBox(height: 30),
            // Google Signup Button Placeholder
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF8884FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                onPressed: () {
                  // TODO: Google signup functionality
                },
                label: const Text(
                  'Continue With Google',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: const Icon(
                  Icons.g_mobiledata,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Already have account - Go to Login
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF8884FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget signupForm() {
    return Center(
      child: SizedBox(
        width: 300,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
          decoration: BoxDecoration(
            color: const Color(0xFFFDE2FF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Email Field
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Basic email validation
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFD7BCE8),
                    hintText: 'Email',
                    hintStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Password Field
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFD7BCE8),
                    hintText: 'Password',
                    hintStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Confirm Password Field
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFD7BCE8),
                    hintText: 'Confirm Password',
                    hintStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Signup Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0xFF8884FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final String email = emailController.text.trim();
                    final String password = passwordController.text;

                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    // ✅ FIXED: Changed from login() to signup()
                    final bool success = await _authService.signup(email, password);

                    if (!mounted) return;

                    // Hide loading indicator
                    Navigator.of(context).pop();

                    if (!success) {
                      // Only show error if signup failed
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Signup failed. Email may already be in use.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    }
                    // ✅ FIXED: Removed manual navigation - AuthGate handles it automatically
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}