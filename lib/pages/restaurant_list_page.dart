import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/login_page.dart';
import '../services/api_service.dart';
import '../pages/restaurant_details_page.dart';
import '../pages/favorites_page.dart';
import '../models/user_model.dart';

class RestaurantListPage extends StatefulWidget {
  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  List<dynamic> _restaurants = [];
  List<String> _favoriteRestaurants = [];
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
    _loadFavorites();
    _loadUsername();
  }

  Future<void> _loadRestaurants() async {
    _restaurants = await APIService.getRestaurants();
    setState(() {});
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteRestaurants = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? ''; // Retrieve username
    });
  }

  void _toggleFavorite(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_favoriteRestaurants.contains(id)) {
      _favoriteRestaurants.remove(id);
    } else {
      _favoriteRestaurants.add(id);
    }
    await prefs.setStringList('favorites', _favoriteRestaurants);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $_username - List Resto', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.logout, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = _restaurants[index];
          final isFavorite = _favoriteRestaurants.contains(restaurant['id']);
          return ListTile(
            leading: Image.network(
              'https://restaurant-api.dicoding.dev/images/small/${restaurant['pictureId']}',
              width: 50,
              height: 50,
            ),
            title: Text(restaurant['name']),
            subtitle: Text(restaurant['city']),
            trailing: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () => _toggleFavorite(restaurant['id']),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RestaurantDetailsPage(
                    restaurant: restaurant,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}