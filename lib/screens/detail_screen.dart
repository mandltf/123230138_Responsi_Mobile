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

  }

  Future<void> _toggleFavorite() async {
    if (_inCart) {
      final items = CartService.instance.getUserCart(widget.username);
      final entry = items.cast<dynamic>().firstWhere(
            (e) => e.productId == widget.product.id,
            orElse: () => null,
          );

      if (entry != null) {
        await CartService.instance.removeItem(entry.hiveKey);
      }
    } else {
      await _addToCart();
      return;
    }

    if (!mounted) return;

    setState(() {
      _inCart = false;
    });
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
              style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
            ),
            
            const SizedBox(height: 4),
           
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
                            size: 18,
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
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                              product.ageRating,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade800,
                                fontSize: 14,
                              ),
                            ),
                          
                          const SizedBox(width: 8),
                          Text(
                            '| ${product.jmlhEpisode} episode',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade800,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 54,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange.shade700,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.play_arrow, size: 20),
                                    SizedBox(width: 4),
                                    Text(
                                      'nonton',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: _toggleFavorite,
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: _inCart ? Colors.red.shade50 : Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _inCart ? Colors.red : Colors.grey.shade400,
                                  width: 1.4,
                                ),
                              ),
                              child: Icon(
                                _inCart ? Icons.favorite : Icons.favorite_border,
                                color: _inCart ? Colors.red : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
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
