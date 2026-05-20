import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/cart_service.dart';
import 'cart_screen.dart';

class DetailScreen extends StatefulWidget {
  final String username;
  final Product product;

  const DetailScreen({
    super.key,
    required this.username,
    required this.product,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _inCart = false;

  @override
  void initState() {
    super.initState();
    final items = CartService.instance.getUserCart(widget.username);
    _inCart = items.any((e) => e.productId == widget.product.id);
  }

  Future<void> _addToCart() async {
    await CartService.instance.addToCart(
      username: widget.username,
      product: widget.product,
    );

    if (!mounted) return;

    setState(() {
      _inCart = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Game ditambahkan ke keranjang.'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Lihat',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CartScreen(username: widget.username),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.posterImage.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  product.posterImage,
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              product.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            
            const SizedBox(height: 8),
           
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${product.rating}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                              product.ageRating,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          
                          const SizedBox(width: 8),
                          Text(
                            '| ${product.jmlhEpisode} episode',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _inCart ? null : _addToCart,
                          child: _inCart ? const Text('Added to Favorites') : const Text('Add to Favorites'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Overview',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        product.synopsis,
                        style: TextStyle(
                          height: 1.5,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
