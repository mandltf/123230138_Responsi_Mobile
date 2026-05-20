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
      productId: int.tryParse(map['productId']?.toString() ?? '') ?? 0,
      title: map['title'] as String? ?? map['titles'] as String? ?? '-',
      posterImage: map['posterImage'] as String? ?? '-',
      rating: (map['rating'] is num)
          ? (map['rating'] as num).toDouble()
          : double.tryParse(map['rating']?.toString() ?? '') ?? 0.0,
    );
  }
}
