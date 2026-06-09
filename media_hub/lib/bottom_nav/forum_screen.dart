import 'package:flutter/material.dart';
import 'package:media_hub/util/app_colors.dart';
import 'package:media_hub/util/mediacard.dart';
import '../util/tmdb_service.dart';
import '../main.dart';

// ─── Data models ────────────────────────────────────────────────────────────

class DiscussedItem {
  final int id;
  final String title;
  final int comments;
  final double rating;
  final IconData icon;
  final String imageUrl;

  const DiscussedItem({
    required this.id,
    required this.title,
    required this.comments,
    required this.rating,
    required this.icon,
    required this.imageUrl,
  });
}

class _ForumTopic {
  final String title;
  final String author;
  final String category;
  final Color categoryColor;
  final String timeAgo;
  final int comments;
  final int likes;

  const _ForumTopic({
    required this.title,
    required this.author,
    required this.category,
    required this.categoryColor,
    required this.timeAgo,
    required this.comments,
    required this.likes,
  });
}

// ─── Mock data ───────────────────────────────────────────────────────────────
final List<_ForumTopic> _recentTopics = [
  _ForumTopic(
    title: 'Melhor filme de 2024?',
    author: 'Carlos Sousa',
    category: 'Filmes',
    categoryColor: AppColors.primary,
    timeAgo: '2h atrás',
    comments: 156,
    likes: 234,
  ),
  _ForumTopic(
    title: 'The Last of Us vs The Walking Dead',
    author: 'Miguel Santos',
    category: 'Séries',
    categoryColor: AppColors.primary,
    timeAgo: '8h atrás',
    comments: 203,
    likes: 318,
  ),
  _ForumTopic(
    title: 'Dune 3 vai mesmo acontecer?',
    author: 'Ana Ferreira',
    category: 'Filmes',
    categoryColor: AppColors.primary,
    timeAgo: '12h atrás',
    comments: 74,
    likes: 98,
  ),
];

// ─── Main page ───────────────────────────────────────────────────────────────
class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tmdbService = TmdbService();
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
          children: [
            Text(
              'Forum',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Text(
              'Discussões da comunidade',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),

            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 16,
                right: 16,
                bottom: 8,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Mais Discutidos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

FutureBuilder<List<DiscussedItem>>(
  future: tmdbService.getMostDiscussed(),
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
        child: Text('Erro: ${snapshot.error}', style: TextStyle(color: Theme.of(context).hintColor)),
      );
    } 
    else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
      final items = snapshot.data!;
      
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          
          final adaptedMedia = Media(
            id: item.id, 
            title: item.title, 
            imageUrl: item.imageUrl,
            type: '${item.comments} comentários', 
            rating: item.rating, 
            overview: '', posterPath: '', releaseDate: ''
          );
          return HorizontalMediaCard(
            media: adaptedMedia,
          );
        },
      );
    }
    
    return const SizedBox.shrink();
  },
),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 16,
                right: 16,
                bottom: 8,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Tópicos Recentes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _recentTopics.length,
              itemBuilder: (context, index) {
                final topic = _recentTopics[index];

                return TopicCard(
                  title: topic.title,
                  author: topic.author,
                  category: topic.category,
                  categoryColor: topic.categoryColor,
                  timeAgo: topic.timeAgo,
                  comments: topic.comments,
                  likes: topic.likes,
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
 