import 'package:flutter/material.dart';
import 'package:media_hub/util/mediacard.dart';
import '../util/tmdb_service.dart';
import '../main.dart';

/**
 * Ecrã principal da aplicação que exibe média em tendência.
 * Mostra filmes e séries populares de forma interleaved.
 */
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/**
 * Estado da página home.
 * Carrega e exibe média em tendência, mantendo o estado durante a navegação.
 */
class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;
  final _tmdbService = TmdbService();
  late Future<List<Media>> _combinedTrendingFuture;
  
  @override
  void initState() {
    super.initState();
    final futureMovies = _tmdbService.getTrending('/movie');
    final futureTvShows = _tmdbService.getTrending('/tv');
    _combinedTrendingFuture = Future.wait([futureMovies, futureTvShows]).then((results) {
      final movies = results[0];
      final tvShows = results[1];

      List<Media> mixedList = [];
      
      if (movies.isNotEmpty) mixedList.add(movies[0]);
      if (tvShows.isNotEmpty) mixedList.add(tvShows[0]);
      if (movies.length > 1) mixedList.add(movies[1]);
      if (tvShows.length > 1) mixedList.add(tvShows[1]);

      return mixedList;
    });
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
          )
        ],
        title: Column(   
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Home',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
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
             Padding(
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
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

  FutureBuilder<List<Media>>(
    future: _combinedTrendingFuture,
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
          child: Text('Error loading: ${snapshot.error}'),
        );
      } 
      else if (snapshot.hasData) {
        final trendingList = snapshot.data!;
        
        return GridView.builder(
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


