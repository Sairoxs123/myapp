import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart'; // Import Provider
import '../services/auth_service.dart'; // Import AuthService
import 'profile.dart';
import 'transactions.dart';
import 'categories.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  User? _currentUser;

  // Placeholder widgets for your screens - replace these with your actual screens
  Widget _buildHomeScreen(User? user) {
    final email = user?.email ?? 'N/A';
    final name = user?.displayName ?? 'User';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome to FinWise, $name!\nYour email is: $email'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await context.read<AuthService>().signOut();
              // Navigator.of(context).pushReplacementNamed('/login'); // Or your login route
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileScreen(User? user) {
    return ProfilePage(user: user);
  }

  Widget _buildTransactionScreen() {
    return const TransactionScreen();
  }

  Widget _buildCategoriesScreen() {
    return const CategoriesScreen();
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Index 0: Home Placeholder'), // Will be replaced by _buildHomeScreen
    Text('Index 1: Transactions Placeholder'),
    Text('Index 2: Categories Placeholder'),
    Text('Index 3: Profile Placeholder'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = context.watch<AuthService>().currentUser;

    // Replace the first placeholder with the actual home screen content
    List<Widget> currentWidgetOptions = List.from(_widgetOptions);
    if (_currentUser != null) {
      currentWidgetOptions[0] = _buildHomeScreen(_currentUser);
      currentWidgetOptions[1] = _buildTransactionScreen();
      currentWidgetOptions[3] = _buildProfileScreen(_currentUser);
      currentWidgetOptions[2] = _buildCategoriesScreen();
    } else {
      // Handle the case where user is null, perhaps show a loading indicator or login prompt
      currentWidgetOptions[0] = const Center(
        child: CircularProgressIndicator(),
      );
      currentWidgetOptions[1] = const Center(
        child: CircularProgressIndicator(),
      );
      currentWidgetOptions[2] = const Center(
        child: CircularProgressIndicator(),
      );
            currentWidgetOptions[3] = const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: Center(child: currentWidgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
