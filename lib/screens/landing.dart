import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package
import '../auth/signup.dart';
import '../auth/login.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  // Define your SVG string here
  final String svgString = '''
<svg width="200" height="200" viewBox="0 0 90 90" fill="none" xmlns="http://www.w3.org/2000/svg">

  <!-- Bars of the chart with open bottoms, drawn using paths -->
  <!-- Bar 1 (leftmost) -->
  <path d="M10 90 L10 70 L25 70 L25 90" stroke="#00C49A" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
  <!-- Bar 2 -->
  <path d="M35 90 L35 50 L50 50 L50 90" stroke="#00C49A" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
  <!-- Bar 3 -->
  <path d="M60 90 L60 30 L75 30 L75 90" stroke="#00C49A" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>

  <!-- Upward trend line with an arrow head -->
  <path d="M5 65 L35 35 L43 40 L70 10" stroke="#00C49A" stroke-width="4"/>
  <path d="M55 13 L70 10 L70 25" stroke="#00C49A" stroke-width="4" />
</svg>
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Use SvgPicture.string for direct SVG string
            SvgPicture.string(
              svgString,
              height: 150, // Adjust the height as needed
              width: 150, // Adjust the width as needed
              // colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn), // Optional: recolor the SVG
              // (Note: if your SVG has fill colors, this might override them)
            ),
            const SizedBox(
              height: 20,
            ), // Add some spacing between logo and text
            const Text(
              'FinWise',
              style: TextStyle(
                fontSize: 50, // Optional: increase font size
                fontWeight: FontWeight.bold, // Optional: make text bold
                color: Color(0xFF00C49A),
              ),
            ),
            const Text("Track. Save. Smile.", style: TextStyle(fontSize: 15)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                )
              },
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
              child: const Text(
                "Log In",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                )
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 238, 236, 236), // Background color from your previous query // Text color (a dark grey/nearly black)
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
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
