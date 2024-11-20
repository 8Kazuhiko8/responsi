import 'package:flutter/material.dart';
import '../pages/favorites_page.dart';
import '../services/api_service.dart';
import '../pages/restaurant_list_page.dart';

class RestaurantDetailsPage extends StatelessWidget {
  final dynamic restaurant;

  RestaurantDetailsPage({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant['name'], style: TextStyle(color: Colors.white),),
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
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://restaurant-api.dicoding.dev/images/small/${restaurant['pictureId']}',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            Text(
              restaurant['name'],
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(restaurant['city']),
            SizedBox(height: 8.0),
            Text('Rating: ${restaurant['rating'].toString()}'),
            SizedBox(height: 16.0),
            Text(restaurant['description']),
          ],
        ),
      ),
    );
  }
}
