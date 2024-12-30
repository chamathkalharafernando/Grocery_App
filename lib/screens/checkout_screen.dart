import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();

    final _colorScheme = const ColorScheme.light(
      primary: Color(0xFF4CAF50), // Fresh green
      secondary: Color(0xFFFFA726), // Warm orange
      surface: Color(0xFFF5F5F5), // Light grey
      background: Color(0xFFFFFFFF), // White
      onPrimary: Color(0xFFFFFFFF), // White text on primary
      onSecondary: Color(0xFF000000), // Black text on secondary
    );

    return Theme(
      data: ThemeData(colorScheme: _colorScheme),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Checkout',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          backgroundColor: _colorScheme.primary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    return ListTile(
                      title: Text(
                        item.name,
                        style: TextStyle(color: _colorScheme.onSecondary),
                      ),
                      trailing: Text(
                        'Rs ${item.price.toStringAsFixed(2)}',
                        style: TextStyle(color: _colorScheme.secondary),
                      ),
                    );
                  },
                ),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: _colorScheme.primary),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _colorScheme.primary),
                  ),
                ),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle: TextStyle(color: _colorScheme.primary),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _colorScheme.primary),
                  ),
                ),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: _colorScheme.primary),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _colorScheme.primary),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty ||
                      addressController.text.isEmpty ||
                      phoneController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields!')),
                    );
                  } else {
                    cartProvider.clearCart();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Order placed successfully!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: _colorScheme.onSecondary,
                  backgroundColor: _colorScheme.secondary,
                  textStyle: const TextStyle(fontSize: 18),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Place Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
