import 'package:flutter/material.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String categoryName;

  const CategoryDetailScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    // Dummy data for transactions
    final List<Map<String, dynamic>> transactions = [
      {'date': 'April 27', 'description': 'Dinner', 'amount': -26.00},
      {'date': 'April 20', 'description': 'Delivery Pizza', 'amount': -18.35},
      {'date': 'April 15', 'description': 'Lunch', 'amount': -15.40},
      {'date': 'April 08', 'description': 'Brunch', 'amount': -12.13},
      {'date': 'March 20', 'description': 'Dinner', 'amount': -27.20},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(categoryName),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // Handle notification icon tap
            },
          ),
        ],
        backgroundColor: const Color(0xFFC8E6C9), // Adjust color to match design
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
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent),
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
                  leading: const Icon(Icons.fastfood), // Replace with appropriate icon based on category/type
                  title: Text(transaction['description']),
                  subtitle: Text(transaction['date']),
                  trailing: Text(
                    '${transaction['amount'] > 0 ? '+' : ''}\$${transaction['amount'].abs().toStringAsFixed(2)}',
                    style: TextStyle(
                      color: transaction['amount'] > 0 ? Colors.green : Colors.redAccent,
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
                // Navigator.push(context, MaterialPageRoute(builder: (context) => AddTransactionScreen(categoryName: categoryName)));
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
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green, // Adjust color to match design
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}