import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'package:myapp/main.dart';
import 'package:myapp/models/transaction_model.dart';
import 'package:myapp/models/categories_model.dart';

class AddTransactionScreen extends StatefulWidget {
  final String categoryName;
  const AddTransactionScreen({super.key, required this.categoryName});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  User? _currentUser;
  @override
  void initState() {
    super.initState();
    _getCategories();
    _selectedCategory = widget.categoryName;
  }

   List<String> categories = [];

  Future<void> _getCategories() async {
    List<CategoriesModel> query = await isar.categoriesModels.where().findAll();
    List<String> temp = [];
    if (query.isNotEmpty) {
      query.forEach((category) => temp.add(category.categoryName));
      setState(() {
        categories = temp;
      });
    }
  }

  List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _saveTransaction() async {
    if (_currentUser?.uid != null) {
      final uid = _currentUser?.uid ?? "temp";
      final transaction = {
        'timestamp': _selectedDate,
        'category': _selectedCategory,
        'amount': double.parse(_amountController.text),
        'title': _titleController.text,
        'message': _messageController.text,
        'type' : 'expense'
      };

      await isar.writeTxn(() async {
        await isar.transactionModels.put(
          TransactionModel(
            timestamp: _selectedDate,
            category: _selectedCategory!,
            amount: double.parse(_amountController.text),
            title: _titleController.text,
            message: _messageController.text,
            type: 'expense'
          )
        );
      });

      await FirebaseFirestore.instance.collection("users").doc(uid).collection("transactions").add(transaction);
      showDialog(context: context, builder:
      (BuildContext dialogContext) {
        return AlertDialog(
        title: const Text('Success'),
        content: const Text('Transaction added successfully!'),
        actions: <Widget>[
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Dismiss dialog
              Navigator.of(context).pop(); // Dismiss AddTransactionScreen
            },
          )
        ],
      );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = context.watch<AuthService>().currentUser;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Add Expenses'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      DateFormat('yyyy-MM-dd').format(_selectedDate), // Corrected DateFormat usage
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              value: _selectedCategory,
              hint: const Text('Select the category'),
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Expense Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _messageController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Enter Message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _saveTransaction,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                backgroundColor: const Color(0xFF66BB6A),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}