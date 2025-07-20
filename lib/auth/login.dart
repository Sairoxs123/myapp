import 'package:myapp/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import "../services/auth_service.dart";
import '../screens/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false; // State variable for loading status
  bool _isPasswordVisible = false;

  // 1. Declare TextEditingControllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Renamed and made async. Returns an error message string or null for success.
  Future<String?> _performSignIn(String email, String password) async {
    // Basic validation (you'd have more robust validation here)
    if (email.isEmpty || password.isEmpty) {
      return "Please fill in all fields.";
    }

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.logInWithEmailAndPassword(email, password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        return 'The email address is not valid.';
      } else {
        return 'An unknown error occurred: ${e.message}';
      }
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }

  Future<void> _handleSignInButtonPressed() async {
    setState(() {
      _isLoading = true;
    });
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    String? errorMessage = await _performSignIn(email, password);

    if (!mounted) return; // Check if the widget is still in the tree

    setState(() {
      _isLoading = false;
    });

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AutofillGroup(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 250,
                color: Color(0xFF00C49A),
                child: SizedBox(
                  child: Center(
                    child: Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              Transform.translate(
                offset: const Offset(
                  0.0,
                  -30.0,
                ), // Adjust this value to control overlap
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 50.0,
                    left: 30.0,
                    right: 30.0,
                    bottom: 50.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 32.0,
                      ), // Spacing between label and input
                      TextFormField(
                        controller: _emailController, // Assign controller
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText:
                              'Enter email', // Placeholder text when field is empty
                          hintText:
                              'e.g., john.doe@example.com', // Example text
                          border:
                              OutlineInputBorder(), // Adds a border around the input field
                          prefixIcon: Icon(Icons.email), // Optional icon
                        ),
                        autofillHints: const [AutofillHints.email],
                      ),
                      const SizedBox(height: 32.0),
                      TextFormField(
                        controller: _passwordController, // Assign controller
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText:
                              'Enter your password', // Placeholder text when field is empty
                          border:
                              OutlineInputBorder(), // Adds a border around the input field
                          prefixIcon: Icon(Icons.lock), // Optional icon
                          suffixIcon: IconButton(
                            padding: EdgeInsets.zero, // Removes default padding
                            constraints:
                                const BoxConstraints(), // Allows the button to be smaller
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        autofillHints: const [AutofillHints.password],
                      ),
                      const SizedBox(height: 30.0),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : _handleSignInButtonPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF00C49A,
                          ), // Background color from your previous query
                          foregroundColor: const Color(
                            0xFF212121,
                          ), // Text color (a dark grey/nearly black)
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              25.0,
                            ), // Half of the height for full pill shape
                          ),
                          elevation: 0, // No shadow for a flat look
                          // You can also use fixed size if you want a specific button size
                          // minimumSize: Size(200, 50),
                          // maximumSize: Size(double.infinity, 50),
                          minimumSize: Size(200, 50),
                        ),
                        child: _isLoading
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Logging in...",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                "Log In",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                      const SizedBox(height: 32.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    // Disable if loading
                                    // Navigate to LoginPage
                                    //Navigator.pushReplacement(
                                    //  context,
                                    //  MaterialPageRoute(builder: (context) => const LoginPage()),
                                    //);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpPage(),
                                      ),
                                    );
                                  },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Color(0xFF00C49A),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
