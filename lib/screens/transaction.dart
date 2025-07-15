import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Transaction {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String date;
  final String category;
  final double amount;

  Transaction({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.date,
    required this.category,
    required this.amount,
  });
}

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  // Sample data for the transaction list
  final List<Transaction> _transactions = [
    Transaction(
        icon: Icons.account_balance_wallet_outlined,
        iconColor: Colors.blue.shade300,
        title: 'Salary',
        date: '18:27 - April 30',
        category: 'Monthly',
        amount: 4000.00),
    Transaction(
        icon: Icons.shopping_basket_outlined,
        iconColor: Colors.orange.shade300,
        title: 'Groceries',
        date: '17:00 - April 24',
        category: 'Pantry',
        amount: -100.00),
    Transaction(
        icon: Icons.home_outlined,
        iconColor: Colors.purple.shade300,
        title: 'Rent',
        date: '8:30 - April 15',
        category: 'Rent',
        amount: -674.40),
    Transaction(
        icon: Icons.directions_bus_outlined,
        iconColor: Colors.green.shade300,
        title: 'Transport',
        date: '7:30 - April 08',
        category: 'Fuel',
        amount: -4.13),
  ];

  final List<Transaction> _marchTransactions = [
    Transaction(
        icon: Icons.fastfood_outlined,
        iconColor: Colors.red.shade300,
        title: 'Food',
        date: '19:30 - March 31',
        category: 'Dinner',
        amount: -70.40),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set a default white background
      appBar: AppBar(
        backgroundColor: const Color(0xFF2ECC71),
        elevation: 0,
        title: Text(
          'Transaction',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // This container holds the green header content.
            Container(
              color: const Color(0xFF2ECC71),
              padding: const EdgeInsets.only(top: 20, bottom: 60), // Note the bottom padding
              child: Column(
                children: [
                  _buildBalanceCard(),
                  const SizedBox(height: 20),
                  _buildIncomeExpenseRow(),
                ],
              ),
            ),
            // This Transform widget pulls the white container up over the green one.
            Transform.translate(
              offset: const Offset(0.0, -40.0), // Adjust this offset to control the overlap
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
                ),
                child: _buildTransactionList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds the total balance card
  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: const Column(
        children: [
          Text(
            'Total Balance',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            '\$7,783.00',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // Builds the row containing the Income and Expense cards
  Widget _buildIncomeExpenseRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoCard(
              icon: Icons.arrow_upward,
              iconColor: Colors.green,
              title: 'Income',
              amount: '\$4,120.00',
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _buildInfoCard(
              icon: Icons.arrow_downward,
              iconColor: Colors.blue,
              title: 'Expense',
              amount: '\$1,187.40',
            ),
          ),
        ],
      ),
    );
  }

  // A reusable widget for the income and expense cards
  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Builds the list of transactions below the header
  Widget _buildTransactionList() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthSectionHeader('April', Icons.calendar_today_outlined),
          ..._transactions.map((tx) => _buildTransactionItem(tx)),
          const SizedBox(height: 20),
          _buildMonthSectionHeader('March', null), // No icon for March as per design
          ..._marchTransactions.map((tx) => _buildTransactionItem(tx)),
        ],
      ),
    );
  }

  // Builds the header for a month section (e.g., "April")
  Widget _buildMonthSectionHeader(String title, IconData? icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          if (icon != null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2ECC71).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF2ECC71), size: 20),
            ),
        ],
      ),
    );
  }

  // A reusable widget for a single transaction item in the list
  Widget _buildTransactionItem(Transaction tx) {
    final bool isIncome = tx.amount > 0;
    final String amountString = '${isIncome ? '' : '-'}\$${tx.amount.abs().toStringAsFixed(2)}';
    final Color amountColor = isIncome ? Colors.green : Colors.blue.shade600;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tx.iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(tx.icon, color: tx.iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          // Title and Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  tx.date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          // Category
          Text(
            tx.category,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(width: 10),
          // Vertical Divider
          Container(
            height: 30,
            width: 1,
            color: Colors.grey.shade300,
          ),
          const SizedBox(width: 10),
          // Amount
          SizedBox(
            width: 90,
            child: Text(
              amountString,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: amountColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}