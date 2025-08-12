import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
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

class Month {
  final String name;
  final List<Transaction> transactions;

  Month({required this.name, required this.transactions});
}

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<Month> transactions = [];
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

  Future<void> _getData() async {
    List<TransactionModel> query = await isar.transactionModels
        .where()
        .sortByTimestampDesc()
        .findAll();
    Map<String, List<Transaction>> transactionsPerMonth = {};

    if (query.isNotEmpty) {
      for (final transaction in query) {
        DateTime date = transaction.timestamp;
        String month = months[date.month - 1];
        if (transactionsPerMonth.containsKey(month)) {
          transactionsPerMonth[month]!.add(
            Transaction(
              icon: Icons.fastfood_outlined,
              iconColor: Colors.red.shade300,
              title: transaction.title,
              date: "${date.hour}:${date.minute} - ${months[date.month - 1]}",
              category: transaction.category,
              amount: transaction.amount,
              type: transaction.type,
            ),
          );
        } else {
          transactionsPerMonth[month] = [
            Transaction(
              icon: Icons.fastfood_outlined,
              iconColor: Colors.red.shade300,
              title: transaction.title,
              date: "${date.hour}:${date.minute} - ${months[date.month - 1]}",
              category: transaction.category,
              amount: transaction.amount,
              type: transaction.type,
            ),
          ];
        }
      }
      List<Month> temp = [];
      transactionsPerMonth.forEach((key, value) {
        temp.add(Month(name: key, transactions: value));
      });
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

  // Sample data for the transaction list

  @override
  void initState() {
    super.initState();
    // Get the current user right after the widget is initialized
    // Using WidgetsBinding.instance.addPostFrameCallback to ensure context is available
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set a default white background
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF2ECC71),
        elevation: 0,
        title: Text(
          'Transaction',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF2ECC71),
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 60,
            ), // Note the bottom padding
            child: Column(
              children: [
                _buildBalanceCard(),
                const SizedBox(height: 20),
                _buildIncomeExpenseRow(),
              ],
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0.0, -40.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(40.0),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [_buildTransactionList()],
                ),
              ),
            ),
          ),
        ],
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
          ),
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
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
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
          ...transactions.map((month) => _buildMonthTransactions(month)),
        ],
      ),
    );
  }

  Widget _buildMonthTransactions(Month month) {
    return Column(
      children: [
        _buildMonthSectionHeader(month.name, Icons.calendar_today_outlined),
        ...month.transactions.map((tx) => _buildTransactionItem(tx)),
        const SizedBox(height: 20),
      ],
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
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
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
    final bool isIncome = tx.type == "income";
    final String amountString =
        '${isIncome ? '' : '-'}\$${tx.amount.abs().toStringAsFixed(2)}';
    final Color amountColor = isIncome ? Colors.green : Colors.red;

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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
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
          Container(height: 30, width: 1, color: Colors.grey.shade300),
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
