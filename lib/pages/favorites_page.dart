import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../pages/restaurant_details_page.dart';
import '../pages/restaurant_list_page.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> _favoriteRestaurants = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteRestaurants = prefs.getStringList('favorites') ?? [];
    });
  }

  void _removeFavorite(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteRestaurants.remove(id);
    });
    prefs.setStringList('favorites', _favoriteRestaurants);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Restaurants', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RestaurantListPage()),
            );
          },
        ),
      ),
      body: _favoriteRestaurants.isEmpty
          ? Center(child: Text('No favorite restaurants yet.'))
          : ListView.builder(
        itemCount: _favoriteRestaurants.length,
        itemBuilder: (context, index) {
          final restaurantId = _favoriteRestaurants[index];
          return FutureBuilder<dynamic>(
            future: APIService.getRestaurantDetails(restaurantId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListTile(title: Text('Loading...'));
              } else if (snapshot.hasError) {
                return ListTile(title: Text('Error loading restaurant'));
              }

              final restaurant = snapshot.data;
              return ListTile(
                leading: Image.network(
                  'https://restaurant-api.dicoding.dev/images/small/${restaurant['pictureId']}',
                  width: 50,
                  height: 50,
                ),
                title: Text(restaurant['name']),
                subtitle: Text(restaurant['city']),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _removeFavorite(restaurantId),
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
          );
        },
      ),
    );
  }
}
