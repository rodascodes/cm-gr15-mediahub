import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_hub/util/app_colors.dart';

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
    categoryColor: AppColors.navbarSelectedColor,
    timeAgo: '2h atrás',
    comments: 156,
    likes: 234,
  ),
  _ForumTopic(
    title: 'Recomendações de sci-fi para iniciantes',
    author: 'Rita Mendes',
    category: 'Livros',
    categoryColor: AppColors.navbarSelectedColor,
    timeAgo: '5h atrás',
    comments: 89,
    likes: 145,
  ),
  _ForumTopic(
    title: 'The Last of Us vs The Walking Dead',
    author: 'Miguel Santos',
    category: 'Séries',
    categoryColor: AppColors.navbarSelectedColor,
    timeAgo: '8h atrás',
    comments: 203,
    likes: 318,
  ),
  _ForumTopic(
    title: 'Dune 3 vai mesmo acontecer?',
    author: 'Ana Ferreira',
    category: 'Filmes',
    categoryColor: AppColors.navbarSelectedColor,
    timeAgo: '12h atrás',
    comments: 74,
    likes: 98,
  ),
];

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _DiscussedCard extends StatelessWidget {
  final _DiscussedItem item;

  const _DiscussedCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/info'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${item.comments}',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        item.rating.toString(),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final String name;

  const _AvatarCircle({required this.name});

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((e) => e[0]).take(2).join()
        : '?';
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.grey[300],
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final _ForumTopic topic;

  const _TopicCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AvatarCircle(name: topic.author),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 2,
                  children: [
                    Text(
                      topic.author,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const Text(' • ',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: topic.categoryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        topic.category,
                        style: TextStyle(
                          color: topic.categoryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Text(' • ',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(
                      topic.timeAgo,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${topic.comments}',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.thumb_up_alt_outlined,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${topic.likes}',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Main page ───────────────────────────────────────────────────────────────

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Forum',
              style: TextStyle(
                color: AppColors.navbarSelectedColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
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

            // ── Mais Discutidos ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, top: 16, right: 16, bottom: 8),
              child: Row(
                children: const [
                  Icon(Icons.trending_up,
                      size: 18, color: AppColors.navbarSelectedColor),
                  SizedBox(width: 6),
                  Text(
                    'Mais Discutidos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _mostDiscussed.length,
              itemBuilder: (context, index) =>
                  _DiscussedCard(item: _mostDiscussed[index]),
            ),

            // ── Tópicos Recentes ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, top: 16, right: 16, bottom: 8),
              child: Row(
                children: const [
                  Icon(Icons.access_time,
                      size: 18, color: AppColors.navbarSelectedColor),
                  SizedBox(width: 6),
                  Text(
                    'Tópicos Recentes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _recentTopics.length,
              itemBuilder: (context, index) =>
                  _TopicCard(topic: _recentTopics[index]),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
