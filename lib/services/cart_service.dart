import 'package:hive_flutter/hive_flutter.dart';

import '../models/cart_entry.dart';
import '../models/product.dart';

class CartService {
  CartService._();
  static final CartService instance = CartService._();

  static const String boxName = 'cart_box';
  late final Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(boxName);
  }

  Box get box => _box;

  List<CartEntry> getUserCart(String username) {
    final items = <CartEntry>[];

    for (final key in _box.keys) {
      final raw = _box.get(key);
      if (raw is Map && raw['username'] == username) {
        items.add(CartEntry.fromMap(key, raw));
      }
    }

    return items;
  }

  Future<void> addToCart({
    required String username,
    required Product product,
  }) async {
    for (final key in _box.keys) {
      final raw = _box.get(key);
      if (raw is Map &&
          raw['username'] == username &&
          raw['productId'] == product.id) {
        // Product already exists in this user's cart.
        return;
      }
    }

    await _box.add({
      'username': username,
      'productId': product.id,
      'title': product.title,
      'rating': product.rating,
      'posterImage': product.posterImage,
    });
  }

  int getUserCartTotalGames(String username) {
    return getUserCart(username).length;
  }

  Future<void> removeItem(dynamic key) async {
    await _box.delete(key);
  }
}
