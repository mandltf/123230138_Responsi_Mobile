class Product {
  final int id;
  final String title;
  final String posterImage;
  final String synopsis;
  final int jmlhEpisode;
  final double rating;
  final String ageRating;

  const Product({
    required this.id,
    required this.title,
    required this.posterImage,
    required this.synopsis,
    required this.jmlhEpisode, //
    required this.ageRating,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final id = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    final attrs = json['attributes'] as Map<String, dynamic>? ?? {};

    final title = attrs['canonicalTitle'] as String?
        ?? (attrs['titles'] is Map ? (attrs['titles'] as Map)['en'] as String? : null)
        ?? '-';

    final posterImage = (attrs['posterImage'] is Map
            ? (attrs['posterImage'] as Map)['small'] ?? (attrs['posterImage'] as Map)['medium'] ?? (attrs['posterImage'] as Map)['original']
            : attrs['posterImage']) as String? ?? '-';

    final synopsis = attrs['synopsis'] as String? ?? '-';
    final jmlhEpisode = (attrs['episodeCount'] as num?)?.toInt() ?? 0;
    final rating = double.tryParse((attrs['averageRating'] ?? attrs['rating'])?.toString() ?? '') ?? 0.0;
    final ageRating = attrs['ageRating'] as String? ?? '-';

    return Product(
      id: id,
      title: title,
      posterImage: posterImage,
      synopsis: synopsis,
      jmlhEpisode: jmlhEpisode,
      ageRating: ageRating,
      rating: rating,
    );
  }
}
