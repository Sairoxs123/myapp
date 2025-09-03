import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'category_detail_screen.dart';
import 'package:myapp/main.dart';
import 'package:myapp/models/categories_model.dart';
import 'package:myapp/screens/add_category_screen.dart';

class Category {
  final String name;
  final int iconCodePoint;

  Category({required this.name, required this.iconCodePoint});
}

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> categories = [];

  Future<void> _getCategories() async {
    List<CategoriesModel> query = await isar.categoriesModels.where().findAll();
    List<Category> temp = [];
    if (query.isNotEmpty) {
      query.forEach((category) => temp.add(Category(name: category.categoryName, iconCodePoint: category.iconCodePoint)));
      setState(() {
        categories = temp;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

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
                    ...categories.map((category) {
                      return _buildCategoryTile(IconData(category.iconCodePoint, fontFamily: 'MaterialIcons'), category.name, context);
                    }),
                    _buildCategoryTile(Icons.add, 'More', context),
                  ]
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
            builder: (context) => label != "More" ? CategoryDetailScreen(categoryName: label) : const AddCategoryScreen(),
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
