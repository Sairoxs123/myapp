import 'package:flutter/material.dart';
import 'add_transaction_screen.dart';
import 'package:isar/isar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'package:myapp/main.dart';
import 'package:myapp/models/transaction_model.dart';
import 'package:myapp/screens/home.dart';

class Transaction {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String date;
  final String category;
  final double amount;
  final String type;

  Transaction({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.date,
    required this.category,
    required this.amount,
    required this.type,
  });
}

class CategoryDetailScreen extends StatefulWidget {
  final String categoryName;
  const CategoryDetailScreen({super.key, required this.categoryName});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  List<Transaction> transactions = [];

  Future<void> _getData(String uid) async {
    final List<TransactionModel> query = await isar.transactionModels.filter().categoryEqualTo(this.widget.categoryName).findAll();
    List<Transaction> temp = [];
    if (query.isNotEmpty) {
      for (final transaction in query) {
        temp.add(
          Transaction(
            icon: Icons.fastfood_outlined,
            iconColor: Colors.red.shade300,
            title: transaction.title,
            date: "${months[transaction.timestamp.month - 1]} ${transaction.timestamp.day}",
            category: transaction.category,
            amount: transaction.amount,
            type: transaction.type,
          ),
        );
      }
      setState(() {
        transactions = temp;
      });
    } else {
            if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('No Transactions'),
              content: const Text("You haven't added any transactions yet."),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss dialog
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  User? _currentUser;

  @override
  void initState() {
    super.initState();
        WidgetsBinding.instance.addPostFrameCallback((_) {
      _currentUser = Provider.of<AuthService>(
        context,
        listen: false,
      ).currentUser;
      if (_currentUser != null) {
        _getData(_currentUser!.uid);
      } else {
        // Handle case where user is not logged in, maybe navigate to login or show a message
        print("User not logged in.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dummy data for transactions

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(this.widget.categoryName),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // Handle notification icon tap
            },
          ),
        ],
        backgroundColor: const Color(
          0xFFC8E6C9,
        ), // Adjust color to match design
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color(0xFFC8E6C9), // Adjust color to match design
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Total Balance',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Text(
                          '\$7,783.00',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          'Total Expense',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Text(
                          '-\$1,187.40',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                LinearProgressIndicator(
                  value: 0.3, // Example progress value
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('30% Of Your Expenses, Looks Good.'),
                    Text('\$20,000.00'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return ListTile(
                  leading: const Icon(
                    Icons.fastfood,
                  ), // Replace with appropriate icon based on category/type
                  title: Text(transaction.title),
                  subtitle: Text(transaction.date),
                  trailing: Text(
                    '${transaction.type != "expense" ? '+' : '-'}\$${transaction.amount.abs().toStringAsFixed(2)}',
                    style: TextStyle(
                      color: transaction.type != "expense"
                          ? Colors.green
                          : Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to Add Transaction screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTransactionScreen(
                      categoryName: this.widget.categoryName,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Adjust color to match design
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Center(
                child: const Text(
                  'Add Expenses', // Or 'Add Income' depending on context
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
