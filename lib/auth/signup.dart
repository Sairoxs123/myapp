import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import '../screens/home.dart';
import "../services/auth_service.dart";

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false; // State variable for loading status
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // 1. Declare TextEditingControllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // 4. Dispose of the controllers when the widget is disposed.
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Renamed and made async. Returns an error message string or null for success.
  Future<String?> _performSignUp(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    // Basic validation (you'd have more robust validation here)
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return "Please fill in all fields.";
    }
    if (password != confirmPassword) {
      return "Passwords do not match.";
    }

    final passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*(),.?":{}|<>])(?=.{8,}).*$',
    );
    if (!passwordRegex.hasMatch(password)) {
      return "Password must be minimum 8 characters long with 1 uppercae, 1 number and 1 special character.";
    }

    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    if (!emailRegex.hasMatch(email)) {
      return "Please enter a valid email address.";
    }

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.signUpWithEmailAndPassword(name, email, password);
      return null;
    } on FirebaseAuthException catch (e) {
      // Handle various Firebase authentication errors
      FirebaseAuth.instance.currentUser?.delete();
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
      FirebaseAuth.instance.currentUser?.delete();
      return 'An unexpected error occurred: $e';
    }
  }

  Future<void> _handleSignUpButtonPressed() async {
    setState(() {
      _isLoading = true;
    });

    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    String? errorMessage = await _performSignUp(
      fullName,
      email,
      password,
      confirmPassword,
    );

    if (!mounted) return; // Check if the widget is still in the tree

    setState(() {
      _isLoading = false;
    });

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } else {
      // Successfully signed up, show dialog and then navigate
      if (mounted) {
        // Check if the widget is still in the tree
        showDialog(
          context: context,
          barrierDismissible: false, // User must tap button to close
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Verification Email Sent"),
              content: Text(
                "A verification email has been sent to $email. Please check your inbox (and spam folder) to verify your account before logging in.",
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss dialog
                    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage())); // Navigate to Login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
              ],
            );
          },
        );
      }
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
                      "Create Account",
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
                      // Spacing between label and input
                      const SizedBox(
                        height: 32.0,
                      ), // Spacing between label and input)
                      TextField(
                        controller: _fullNameController, // Assign controller
                        decoration: InputDecoration(
                          labelText:
                              'Enter your fullname', // Placeholder text when field is empty
                          hintText: 'e.g., John Doe', // Example text
                          border:
                              OutlineInputBorder(), // Adds a border around the input field
                          prefixIcon: Icon(Icons.person), // Optional icon
                        ),
                      ),
                      const SizedBox(
                        height: 32.0,
                      ), // Spacing between label and input
                      TextField(
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
                        autofillHints: const [AutofillHints.newUsername, AutofillHints.email],
                      ),
                      const SizedBox(height: 32.0),
                      TextField(
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
                        autofillHints: const [AutofillHints.newPassword],
                      ),
                      const SizedBox(height: 32.0),
                      TextField(
                        controller:
                            _confirmPasswordController, // Assign controller
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          labelText:
                              'Re-enter your password', // Placeholder text when field is empty
                          border:
                              OutlineInputBorder(), // Adds a border around the input field
                          prefixIcon: Icon(Icons.lock), // Optional icon
                          suffixIcon: IconButton(
                            padding: EdgeInsets.zero, // Removes default padding
                            constraints:
                                const BoxConstraints(), // Allows the button to be smaller
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : _handleSignUpButtonPressed,
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
                                    "Signing Up...",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                "Sign Up",
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
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                                  },
                            child: const Text(
                              "Log In",
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
