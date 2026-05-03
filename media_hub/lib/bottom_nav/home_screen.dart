import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart'; Irá ser implementado quando o Pedro mandar o código da página Info
import 'package:media_hub/mediacard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Media> trendingList = [
      Media('Dune: Part Two', 'Movie', 8.9, Icons.movie, Colors.orange),
      Media('The Last of Us', 'Series', 9.2, Icons.tv, Colors.green),
      Media('Project Hail Mary', 'Book', 9.1, Icons.book, Colors.purple),
    ];

    final List<Media> recommendedList = [
      Media('The Batman', 'Movie', 8.5, Icons.movie, Colors.blue),
      Media('Stranger Things', 'Series', 8.7, Icons.tv, Colors.red),
      Media('The Midnight Library', 'Book', 8.8, Icons.book, Colors.teal),
    ];

    final List<Media> classifiedList = [
      Media('Interstellar', 'Movie', 8.8, Icons.movie, Colors.brown),
      Media('Breaking Bad', 'Series', 9.5, Icons.tv, Colors.indigo),
      Media('Sapiens', 'Book', 9.0, Icons.book, Colors.cyan),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Home',
              style: TextStyle(color: Color.fromARGB(255, 119, 0, 255)),
            ),
            Text('For You', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                top: 16.0,
                right: 16.0,
                bottom: 8.0,
              ),
              child: Text(
                'Trending',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 119, 0, 255),
                ),
              ),
            ),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemCount: trendingList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final media = trendingList[index];
                return MediaCard(
                  title: media.title,
                  type: media.type,
                  rating: media.rating,
                  icon: media.icon,
                  color: media.color,
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                top: 12.0,
                right: 16.0,
                bottom: 8.0,
              ),
              child: Text(
                'Recommended',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 119, 0, 255),
                ),
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: recommendedList.length,
              itemBuilder: (context, index) {
                final media = recommendedList[index];
                return HorizontalMediaCard(
                  title: media.title,
                  type: media.type,
                  rating: media.rating,
                  icon: media.icon,
                  color: media.color,
                );
              },
            ),

            const Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                top: 12.0,
                right: 16.0,
                bottom: 8.0,
              ),
              child: Text(
                'Classified Recently',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 119, 0, 255),
                ),
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: classifiedList.length,
              itemBuilder: (context, index) {
                final media = classifiedList[index];
                return HorizontalMediaCard(
                  title: media.title,
                  type: media.type,
                  rating: media.rating,
                  icon: media.icon,
                  color: media.color,
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


