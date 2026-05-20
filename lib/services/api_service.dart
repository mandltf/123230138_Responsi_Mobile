import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiService {
  static const _baseUrl = 'https://kitsu.io/api/edge/anime/?page[limit]=20&page[offset]=0';

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to load products. Status: ${response.statusCode}');
    }

    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> list = data['data'];

    return list.map((json) => Product.fromJson(json)).toList();
  }
  

  static Future<Product> fetchProductById(int id) async {
    final url = 'https://kitsu.io/api/edge/anime/$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load product. Status: ${response.statusCode}');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    final item = data['data'];

    if (item is Map<String, dynamic>) {
      return Product.fromJson(item);
    }

    if (item is List && item.isNotEmpty && item.first is Map<String, dynamic>) {
      return Product.fromJson(item.first as Map<String, dynamic>);
    }

    throw Exception('Unexpected product response format.');
  }
}
