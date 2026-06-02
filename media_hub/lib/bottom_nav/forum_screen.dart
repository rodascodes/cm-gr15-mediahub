import 'package:flutter/material.dart';
import 'package:media_hub/util/app_colors.dart';
import 'package:media_hub/util/mediacard.dart';
import '../main.dart';

// ─── Data models ────────────────────────────────────────────────────────────

class _DiscussedItem {
  final String title;
  final int comments;
  final double rating;
  final IconData icon;
  final Color color;

  const _DiscussedItem({
    required this.title,
    required this.comments,
    required this.rating,
    required this.icon,
    required this.color,
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

final List<_DiscussedItem> _mostDiscussed = [
  _DiscussedItem(
    title: 'Dune: Part Two',
    comments: 1243,
    rating: 8.9,
    icon: Icons.movie,
    color: Colors.orange,
  ),
  _DiscussedItem(
    title: 'The Last of Us',
    comments: 2156,
    rating: 9.2,
    icon: Icons.tv,
    color: Colors.green,
  ),
  _DiscussedItem(
    title: 'Atomic Habits',
    comments: 876,
    rating: 8.7,
    icon: Icons.book,
    color: Colors.purple,
  ),
];

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
    title: 'Recomendações de sci-fi para iniciantes',
    author: 'Rita Mendes',
    category: 'Livros',
    categoryColor: AppColors.primary,
    timeAgo: '5h atrás',
    comments: 89,
    likes: 145,
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

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _mostDiscussed.length,
              itemBuilder: (context, index) {
                final item = _mostDiscussed[index];

                return HorizontalMediaCard(
                  title: item.title,
                  type: '${item.comments} comentários',
                  rating: item.rating,
                  icon: item.icon,
                  color: item.color,
                );
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
