import 'package:flutter/material.dart';
import 'package:media_hub/util/mediacard.dart';
//import 'package:go_router/go_router.dart'; Irá ser implementado quando o Pedro mandar o código da página Info


class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Media> searchList = [
      Media(
        id: 1,
        title: 'Dune: Part Two',
        type: 'Movie',
        rating: 8.9,
        icon: Icons.movie,
        color: Colors.orange,
        overview: '',
        posterPath: '',
        releaseDate: '2024',
      ),
      Media(
        id: 2,
        title: 'The Last of Us',
        type: 'Series',
        rating: 9.2,
        icon: Icons.tv,
        color: Colors.green,
        overview: '',
        posterPath: '',
        releaseDate: '2023',
      ),
      Media(
        id: 3,
        title: 'Project Hail Mary',
        type: 'Book',
        rating: 9.1,
        icon: Icons.book,
        color: Colors.purple,
        overview: '',
        posterPath: '',
        releaseDate: '2021',
      ),
      Media(
        id: 4,
        title: 'The Batman',
        type: 'Movie',
        rating: 8.5,
        icon: Icons.movie,
        color: Colors.blue,
        overview: '',
        posterPath: '',
        releaseDate: '2022',
      ),
      Media(
        id: 5,
        title: 'Stranger Things',
        type: 'Series',
        rating: 8.7,
        icon: Icons.tv,
        color: Colors.red,
        overview: '',
        posterPath: '',
        releaseDate: '2016',
      ),
      Media(
        id: 6,
        title: 'The Midnight Library',
        type: 'Book',
        rating: 8.8,
        icon: Icons.book,
        color: Colors.teal,
        overview: '',
        posterPath: '',
        releaseDate: '2020',
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Search',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for movies, series, books...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),

              child: Row(
                children: [
                  CategoryButton(
                    text: "All",
                    colors: const [Color(0xFFB066FE), Color(0xFFE943AD)],
                    onPressed: null,
                  ),
                  const SizedBox(width: 8),

                  CategoryButton(
                    text: "Movies",
                    colors: const [Color(0xFF3399FF), Color(0xFF00B4DB)],
                    onPressed: null,
                  ),
                  const SizedBox(width: 8),

                  CategoryButton(
                    text: "Series",
                    colors: const [Color(0xFF20E2D7), Color(0xFF00C896)],
                    onPressed: null,
                  ),
                  const SizedBox(width: 8),

                  CategoryButton(
                    text: "Books",
                    colors: const [Color(0xFFFF8008), Color(0xFFFF4B2B)],
                    onPressed: null,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: searchList.length,
              itemBuilder: (context, index) {
                final media = searchList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: HorizontalMediaCard(
                    title: media.title,
                    type: media.type,
                    rating: media.rating,
                    icon: media.icon,
                    color: media.color,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String text;
  final List<Color> colors;
  final VoidCallback? onPressed;

  const CategoryButton({
    super.key,
    required this.text,
    required this.colors,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.transparent, 
          shadowColor: Colors.transparent, 
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }
}
