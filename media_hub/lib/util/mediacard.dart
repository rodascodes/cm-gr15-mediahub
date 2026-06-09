import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MediaCard extends StatelessWidget {
  final Media media;

  const MediaCard({
    super.key,
    required this.media,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/info',
          extra: media,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(media.imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(media.title, style: const TextStyle(fontWeight: FontWeight.bold)), 
                  
                  Text(media.type, style: TextStyle(color: Theme.of(context).hintColor)), 
                  
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(media.rating.toStringAsFixed(1)), 
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalMediaCard extends StatelessWidget {
  final String title;
  final String type;
  final double rating;
  final String imageUrl;

  const HorizontalMediaCard({
    super.key,
    required this.title,
    required this.type,
    required this.rating,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/info'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12), 
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, 
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 70, height: 70,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 16), 
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(type, style: TextStyle(color: Theme.of(context).hintColor, fontSize: 14)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(rating.toString(), style: const TextStyle(fontWeight: FontWeight.w500)),
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

class AvatarCircle extends StatelessWidget {
  final String name;

  const AvatarCircle({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '?';
        
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CircleAvatar(
      radius: 20,
      backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
      child: Text(
        initials,
        style: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}

class TopicCard extends StatelessWidget {
  final String title;
  final String author;
  final String category;
  final Color categoryColor;
  final String timeAgo;
  final int comments;
  final int likes;

  const TopicCard({
    super.key,
    required this.title,
    required this.author,
    required this.category,
    required this.categoryColor,
    required this.timeAgo,
    required this.comments,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarCircle(name: author),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 2,
                  children: [
                    Text(author, style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12)),
                    Text(' • ', style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: categoryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(' • ', style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12)),
                    Text(timeAgo, style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 14, color: Theme.of(context).hintColor),
                    const SizedBox(width: 4),
                    Text('$comments', style: TextStyle(color: Theme.of(context).hintColor, fontSize: 13)),
                    const SizedBox(width: 16),
                    Icon(Icons.thumb_up_alt_outlined, size: 14, color: Theme.of(context).hintColor),
                    const SizedBox(width: 4),
                    Text('$likes', style: TextStyle(color: Theme.of(context).hintColor, fontSize: 13)),
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


class Media {
  final int id;

  final String title;
  final String type;
  final double rating;
  final String imageUrl;

  final String overview;
  final String posterPath;
  final String releaseDate;

  Media({
    required this.id,
    required this.title,
    required this.type,
    required this.rating,
    required this.imageUrl,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
  });
}