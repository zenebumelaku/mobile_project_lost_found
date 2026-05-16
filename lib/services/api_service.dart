import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item_model.dart';

class ApiService {
  // Live public REST API — mockapi.io project created for this assignment
  static const String baseUrl =
      'https://6a083b81fa9b27c848fac459.mockapi.io/items';

  Future<List<LostFoundItem>> fetchItems() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List body = jsonDecode(response.body);
      return body.map((e) => LostFoundItem.fromJson(e)).toList();
    }
    throw Exception('Failed to load items (${response.statusCode})');
  }

  Future<LostFoundItem> createItem(LostFoundItem item) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return LostFoundItem.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create item (${response.statusCode})');
  }

  Future<LostFoundItem> updateItem(String id, LostFoundItem item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 200) {
      return LostFoundItem.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to update item (${response.statusCode})');
  }

  Future<void> deleteItem(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete item (${response.statusCode})');
    }
  }
}
