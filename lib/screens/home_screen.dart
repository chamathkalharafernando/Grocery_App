import 'package:flutter/material.dart';
import '../models/grocery_item.dart';
import '../widgets/grocery_item_card.dart';
import 'cart_screen.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<GroceryItem> _groceryItems = [];
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Color scheme
  final _colorScheme = const ColorScheme.light(
    primary: Color(0xFF4CAF50), // Fresh green
    secondary: Color(0xFFFFA726), // Warm orange
    surface: Color(0xFFF5F5F5), // Light grey
    background: Color(0xFFFFFFFF), // White
    onPrimary: Color(0xFFFFFFFF), // White text on primary
    onSecondary: Color(0xFF000000), // Black text on secondary
  );

  Future<void> _loadGroceryData() async {
    final String response =
        await rootBundle.loadString('assets/grocery_data.json');
    final data = json.decode(response) as List;
    setState(() {
      _groceryItems = data.map((item) => GroceryItem.fromJson(item)).toList();
    });
    _fadeController.forward();
  }

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _loadGroceryData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: _colorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: _colorScheme.primary,
          elevation: 0,
        ),
        scaffoldBackgroundColor: _colorScheme.background,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Grocery Store',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Hero(
              tag: 'cart_button',
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const CartScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _groceryItems.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      0,
                      (1 - _fadeAnimation.value) *
                          50 *
                          (index % 2 == 0 ? -1 : 1),
                    ),
                    child: child,
                  );
                },
                child: GroceryItemCard(item: _groceryItems[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}
