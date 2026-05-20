class Product {
  final int id;
  final String title;
  final String posterImage;
  final String synopsis;
  final int jmlhEpisode;
  final double rating;

  const Product({
    required this.id,
    required this.title,
    required this.posterImage,
    required this.synopsis,
    required this.jmlhEpisode, //
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['titles'] as String? ?? '-',
      posterImage: json['posterImage'] as String? ?? '-',
      synopsis: json['synopsis'] as String? ?? '-',
      jmlhEpisode: json['episodeCount'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
    );
  }
}
