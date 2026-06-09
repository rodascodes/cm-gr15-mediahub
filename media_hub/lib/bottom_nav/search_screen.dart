import 'package:flutter/material.dart';
import 'package:media_hub/util/mediacard.dart';
import '../util/tmdb_service.dart';
import '../main.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  final tmdbService = TmdbService();
  String _selectedCategory = 'All'; // Track selected category

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Media>> _getMedia() async {
    final query = _searchController.text.trim();
    
    // If search is empty, show trending based on category
    if (query.isEmpty) {
      if (_selectedCategory == 'Movies') {
        return tmdbService.getTrending('/movie/');
      } else if (_selectedCategory == 'Series') {
        return tmdbService.getTrending('/tv/');
      } else {
        // For 'All', combine movies and TV
        final movies = await tmdbService.getTrending('/movie/');
        final tvShows = await tmdbService.getTrending('/tv/');
        return [...movies, ...tvShows]; //Spread operator to combine lists
      }
    }
    
    // If search has text, search and filter by category
    final results = await tmdbService.search(query);
    if (_selectedCategory == 'Movies') {
      return results.where((media) => media.type == 'Movie').toList();
    } else if (_selectedCategory == 'Series') {
      return results.where((media) => media.type == 'TV Show').toList();
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
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
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                },
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
                    isSelected: _selectedCategory == 'All',
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'All';
                      });
                    },
                  ),
                  const SizedBox(width: 8),

                  CategoryButton(
                    text: "Movies",
                    colors: const [Color(0xFF3399FF), Color(0xFF00B4DB)],
                    isSelected: _selectedCategory == 'Movies',
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'Movies';
                      });
                    },
                  ),
                  const SizedBox(width: 8),

                  CategoryButton(
                    text: "Series",
                    colors: const [Color(0xFF20E2D7), Color(0xFF00C896)],
                    isSelected: _selectedCategory == 'Series',
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'Series';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const SizedBox(height: 16),
  FutureBuilder<List<Media>>(
    future: _getMedia(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        );
      } 
      else if (snapshot.hasError) {
        return Center(
          child: Text('Erro ao carregar filmes: ${snapshot.error}'),
        );
      } 
      else if (snapshot.hasData) {
        final searchResults = snapshot.data!;
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10),

          itemCount: searchResults.length, 
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final media = searchResults[index];
            return MediaCard(
              media: media,
            );
          },
        );
      }
      return const SizedBox.shrink(); 
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
  final bool isSelected;

  const CategoryButton({
    super.key,
    required this.text,
    required this.colors,
    this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isSelected 
          ? LinearGradient(
              colors: colors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )
          : null,
        border: !isSelected 
          ? Border.all(color: Colors.grey[400]!, width: 2)
          : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.transparent : Colors.transparent,
          shadowColor: Colors.transparent, 
          foregroundColor: isSelected ? Colors.white : Colors.grey[600],
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 15, 
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}