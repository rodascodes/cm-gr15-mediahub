import 'package:flutter/material.dart';
import 'package:media_hub/utils/mediacard.dart';
import '../controllers/tmdb_service.dart';
import '../main.dart';

/**
 * Ecrã de pesquisa de média (filmes e séries).
 * Permite filtrar por categoria e pesquisar por palavra-chave.
 */
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

/**
 * Estado do ecrã de pesquisa.
 * Gerencia a pesquisa e filtragem de média por categoria.
 */
class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;
  late TextEditingController _searchController;
  final tmdbService = TmdbService();

  late Future<List<Media>> _trendingFutureMovies;
  late Future<List<Media>> _trendingFutureTV;
  late Future<List<Media>> _currentMediaFuture;

  String _selectedCategory = 'All'; 

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _trendingFutureMovies = tmdbService.getTrending('/movie');
    _trendingFutureTV = tmdbService.getTrending('/tv');
    _currentMediaFuture = _getMedia('');
  }

  /// Obtém a lista de média baseada na pesquisa e categoria selecionada
  Future<List<Media>> _getMedia(String query) async {
    if (query.isEmpty) {
      if (_selectedCategory == 'Movies') {
        return _trendingFutureMovies;
      } else if (_selectedCategory == 'Series') {
        return _trendingFutureTV;
      } else {
        final movies = await _trendingFutureMovies;
        final tvShows = await _trendingFutureTV;
        return [...movies, ...tvShows];
      }
    }
    
    final results = await tmdbService.search(query);
    if (_selectedCategory == 'Movies') {
      return results.where((media) => media.type == 'Movie').toList();
    } else if (_selectedCategory == 'Series') {
      return results.where((media) => media.type == 'TV Show').toList();
    }
    return results;
  }

  /**
   * Atualiza a lista de média exibida com base no texto de pesquisa.
   */
  void _updateSearch() {
    setState(() {
      _currentMediaFuture = _getMedia(_searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //remove the navigation arrow
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
          children: [
            Text(
              'Search',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            Text('Find your favorite content', style: TextStyle(fontSize: 12)),
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
                  _updateSearch();
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
                        _selectedCategory = 'All';
                        _updateSearch();
                    },
                  ),
                  const SizedBox(width: 8),

                  CategoryButton(
                    text: "Movies",
                    colors: const [Color(0xFF3399FF), Color(0xFF00B4DB)],
                    isSelected: _selectedCategory == 'Movies',
                    onPressed: () {
                        _selectedCategory = 'Movies';
                        _updateSearch();
                    },
                  ),
                  const SizedBox(width: 8),

                  CategoryButton(
                    text: "Series",
                    colors: const [Color(0xFF20E2D7), Color(0xFF00C896)],
                    isSelected: _selectedCategory == 'Series',
                    onPressed: () {
                        _selectedCategory = 'Series';
                        _updateSearch();
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const SizedBox(height: 16),


  FutureBuilder<List<Media>>(
    future: _currentMediaFuture,
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
  /// Ótão de categoria com gradient condicional
  /// Representa um filtro de categoria (Filmes, Séries, Todos)
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