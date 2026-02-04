import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'notes_list_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7BCE8),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            const Text(
              'Welcome to Memoa',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 85),
            Container(
              child: loginForm(),
            ),
            const SizedBox(height: 30),
            // Google Login Button Placeholder
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
                onPressed: () {},
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
            // Create Account Button Placeholder
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
                onPressed: () {},
                child: const Text(
                  'Create new account',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loginForm() {
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
                  'Sign In',
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
                    hintText: 'Email/Username',
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
                    if (value == null || value.length < 6) {
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
                // Login Button
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

                    final String email = emailController.text;
                    final String password = passwordController.text;

                    final bool success = await _authService.login(email, password);

                    if (!context.mounted) return;

                    if (success) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotesHomeScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login failed')),
                      );
                    }
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Forget Password
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Forget password clicked")),
                    );
                  },
                  child: const Text(
                    'Forget Password',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      decoration: TextDecoration.underline,
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
