import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/cart_entry.dart';
import '../services/cart_service.dart';

class CartScreen extends StatelessWidget {
  final String username;

  const CartScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final box = CartService.instance.box;

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Favorite')),
      body: ValueListenableBuilder<Box>(
        valueListenable: box.listenable(),
        builder: (context, box, child) {
          final items = CartService.instance.getUserCart(username);

          if (items.isEmpty) {
            return const Center(child: Text('Favorite masih kosong.'));
          }

          final totalGames = items.length;

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _CartItemTile(item: item);
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.grey.shade200,
                child: Text(
                  'Total anime favorite: $totalGames',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartEntry item;

  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: item.posterImage.isEmpty
          ? const Icon(Icons.image_not_supported)
          : Image.network(
              item.posterImage,
              width: 56,
              fit: BoxFit.cover,
            ),
      title: Text(item.title),
      subtitle: Row(
        children: [
          Icon(
            Icons.star,
            size: 16,
            color: Colors.orange.shade700,
          ),
          const SizedBox(width: 6),
          Text(item.rating.toString()),
        ],
      ),
      trailing: IconButton(
        onPressed: () async {
          await CartService.instance.removeItem(item.hiveKey);
        },
        icon: const Icon(Icons.delete, color: Colors.red),
      ),
    );
  }
}
