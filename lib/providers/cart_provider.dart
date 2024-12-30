import 'package:flutter/material.dart';
import '../models/grocery_item.dart';

class CartProvider extends ChangeNotifier {
  final List<GroceryItem> _items = [];

  List<GroceryItem> get items => _items;

  double get totalPrice =>
      _items.fold(0, (total, current) => total + current.price);

  get cart => null;

  void addItem(GroceryItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(GroceryItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
