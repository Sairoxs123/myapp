import 'package:flutter/material.dart';
import 'category_detail_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: const Color(0xFF94D3A2),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Balance and Expense
          _buildBalanceAndExpenseRow(),
          const SizedBox(height: 20),
          // Categories Grid
          Expanded(
            child: Transform.translate(
              offset: const Offset(0.0, -54.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(40.0),
                  ),
                ),
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  padding: const EdgeInsets.only(
                    top: 25,
                    left: 12.5,
                    right: 12.5,
                    bottom: 20,
                  ),
                  children: [
                    _buildCategoryTile(Icons.fastfood, 'Food', context),
                    _buildCategoryTile(
                      Icons.directions_bus,
                      'Transport',
                      context,
                    ),
                    _buildCategoryTile(
                      Icons.medical_services,
                      'Medicine',
                      context,
                    ),
                    _buildCategoryTile(
                      Icons.local_grocery_store,
                      'Groceries',
                      context,
                    ),
                    _buildCategoryTile(Icons.house, 'Rent', context),
                    _buildCategoryTile(Icons.card_giftcard, 'Gifts', context),
                    _buildCategoryTile(Icons.savings, 'Savings', context),
                    _buildCategoryTile(Icons.movie, 'Entertainment', context),
                    _buildCategoryTile(Icons.add, 'More', context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceAndExpenseRow() {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 70),
      decoration: BoxDecoration(color: const Color(0xFF94D3A2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Total Balance',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                'Total Expense',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '\$7,783.00', // Replace with actual balance
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '-\$1,187.40', // Replace with actual expense
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Bar (replace with actual data)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.3, // Replace with actual progress
              backgroundColor: Colors.white.withOpacity(0.5),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.blueAccent,
              ),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '30% Of Your Expenses, Looks GOOD.', // Replace with actual text
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              Text(
                '\$20,000.00', // Replace with actual budget
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(IconData icon, String label, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailScreen(categoryName: label),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color(0xFF94D3A2)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
