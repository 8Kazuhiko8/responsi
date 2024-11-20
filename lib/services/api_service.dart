import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  static Future<List<dynamic>> getRestaurants() async {
    final response = await http.get(Uri.parse('https://restaurant-api.dicoding.dev/list'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['restaurants'];
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  static Future<dynamic> getRestaurantDetails(String id) async {
    final response = await http.get(Uri.parse('https://restaurant-api.dicoding.dev/detail/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['restaurant'];
    } else {
      throw Exception('Failed to load restaurant details');
    }
  }
}