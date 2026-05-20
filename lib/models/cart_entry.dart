class CartEntry {
  final dynamic hiveKey;
  final String username;
  final int productId;
  final String title;
  final String posterImage;
  final double rating;

  const CartEntry({
    required this.hiveKey,
    required this.username,
    required this.productId,
    required this.title,
    required this.posterImage,
    required this.rating,
  });

  factory CartEntry.fromMap(dynamic hiveKey, Map<dynamic, dynamic> map) {
    return CartEntry(
      hiveKey: hiveKey,
      username: map['username'] as String? ?? '',
      productId: map['productId'] as int? ?? 0,
      title: map['titles'] as String? ?? '-',
      posterImage: map['posterImage'] as String? ?? '-',
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
    );
  }
}
