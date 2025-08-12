import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/categories_model.dart';
import 'package:myapp/main.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class AddCategoryScreen extends StatefulWidget {
	const AddCategoryScreen({super.key});

	@override
	State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
	final TextEditingController _nameController = TextEditingController();
	IconData? _selectedIcon;
  User? _currentUser;

	final List<IconData> _iconOptions = [
		Icons.fastfood,
		Icons.shopping_cart,
		Icons.home,
		Icons.directions_car,
		Icons.local_hospital,
		Icons.card_giftcard,
		Icons.savings,
		Icons.movie,
		Icons.more_horiz,
	];

		void _saveCategory() async {
			if (_currentUser?.uid != null) {
        final name = _nameController.text.trim();
			if (name.isEmpty || _selectedIcon == null) {
				showDialog(
					context: context,
					builder: (context) => AlertDialog(
						title: const Text('Error'),
						content: const Text('Please enter a name and select an icon.'),
						actions: [
							TextButton(
								onPressed: () => Navigator.pop(context),
								child: const Text('OK'),
							),
						],
					),
				);
				return;
			}

			// Save to Isar
			await isar.writeTxn(() async {
				await isar.categoriesModels.put(
					CategoriesModel(
						categoryName: name,
						iconCodePoint: _selectedIcon!.codePoint,
					),
				);
			});

      await FirebaseFirestore.instance.collection("users").doc(_currentUser!.uid).collection("categories").add({
        'categoryName': name,
        'iconCodePoint': _selectedIcon!.codePoint,
      });

			showDialog(
				context: context,
				builder: (context) => AlertDialog(
					title: const Text('Success'),
					content: const Text('Category added successfully!'),
					actions: [
						TextButton(
							onPressed: () {
								Navigator.pop(context);
								Navigator.pop(context);
							},
							child: const Text('OK'),
						),
					],
				),
			);
      }
		}

	@override
	void dispose() {
		_nameController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
    _currentUser = context.watch<AuthService>().currentUser;
		return Scaffold(
			appBar: AppBar(
				title: const Text('Add Category'),
				centerTitle: true,
				backgroundColor: const Color(0xFF94D3A2),
			),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						TextFormField(
							controller: _nameController,
							decoration: InputDecoration(
								labelText: 'Category Name',
								border: OutlineInputBorder(
									borderRadius: BorderRadius.circular(8.0),
								),
							),
						),
						const SizedBox(height: 24.0),
						const Text('Select Icon:', style: TextStyle(fontSize: 16)),
						const SizedBox(height: 8.0),
						Wrap(
							spacing: 16.0,
							children: _iconOptions.map((icon) {
								return ChoiceChip(
									label: Icon(icon, size: 32),
									selected: _selectedIcon == icon,
									onSelected: (selected) {
										setState(() {
											_selectedIcon = icon;
										});
									},
									selectedColor: const Color(0xFF94D3A2),
									backgroundColor: Colors.grey[200],
								);
							}).toList(),
						),
						const SizedBox(height: 32.0),
						SizedBox(
							width: double.infinity,
							child: ElevatedButton(
								onPressed: _saveCategory,
								style: ElevatedButton.styleFrom(
									padding: const EdgeInsets.symmetric(vertical: 16.0),
									shape: RoundedRectangleBorder(
										borderRadius: BorderRadius.circular(8.0),
									),
									backgroundColor: const Color(0xFF66BB6A),
								),
								child: const Text('Save', style: TextStyle(fontSize: 18.0)),
							),
						),
					],
				),
			),
		);
	}
}
