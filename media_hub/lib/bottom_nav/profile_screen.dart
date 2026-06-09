import 'package:flutter/material.dart';
import 'package:media_hub/app_util_classes.dart';
import 'package:media_hub/services/auth_service.dart';
import 'package:media_hub/services/user_services.dart';
import 'package:media_hub/util/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:media_hub/util/mediacard.dart';
import 'package:media_hub/util/tmdb_service.dart';

class _MockupUser {
  static int ratings = 247;
  static int hours = 156;
  static int top = 5;
}
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder<AppUser>(
        future: UserServices().getUser(),
        builder: (context, snapshot) {

          //loading stuff
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          //error
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Error loading user"));
          }

          //pog
          final user = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                _Header(user: user),
                _CategorySection(user: user),
                _Ratings(user: user),
                _FavouritesDisplay(user: user),
              ],
            ),
          );
        },
      ),
    );
  }
}

//stat cards to be used on header with information about user ratings , average rating, etc
class _StatCard extends StatelessWidget {
  final String stat, value;

  const _StatCard({required this.stat, required this.value});

  @override
  Widget build(BuildContext context)
  {
    return Container( //container is like using a div in html
      width: 70,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(stat, style: TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),

    );
  }
}

class _Header extends StatelessWidget {
  final AppUser user;
  
  const _Header({required this.user});

  @override
  Widget build(BuildContext context)
  {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 48, 16, 16), //LTRB = Left, Top, Right, Bottom
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.profileHeaderG1, AppColors.profileHeaderG2,],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(user.name, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              GestureDetector(
                child: Icon(Icons.logout_outlined, color: Colors.red),
                onTap: () {
                  AuthService().logout();
                  context.go('/login');
                },
              ),
            ],
          ),
          Text("@${user.username}", style: TextStyle(color: Colors.white70)),
          SizedBox(height: 16), //just to give an empty space before inserting the row with the stat cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatCard(value: "${user.stats.totalMedia}", stat: "Ratings"),
              _StatCard(value: "${user.stats.average}", stat: "Avg. Score"),
              _StatCard(value: "${_MockupUser.hours}h", stat: "Time"),
              _StatCard(value: "Top ${_MockupUser.top}%", stat: ""),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String mediaType;
  final int numberWatched;

  const _CategoryCard({
    required this.icon,
    required this.mediaType,
    required this.numberWatched,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/collection',
          extra: {
            "title": mediaType,
            "items": <Map<String, dynamic>>[],
          },
        );
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.purple),
            const SizedBox(height: 8),
            Text(
              "$numberWatched",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(mediaType),
          ],
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget{
  static const Map<String, IconData> icons = {
    "movies": Icons.movie,
    "tv shows": Icons.tv,
    "books": Icons.book,
  };

  final AppUser user;
  const _CategorySection({required this.user});

  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12), //to give some space
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for(MediaType mediaType in user.media.keys)
                  _CategoryCard(icon: icons[mediaType.name] ?? Icons.help, mediaType: mediaType.name, numberWatched: user.media[mediaType]?.length ?? 0) //in flutter ?? means if there is not any then do this instead
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}

class _RatingRow extends StatelessWidget{
  final int rating;
  final int count;
  
  const _RatingRow({required this.rating, required this.count});

  @override
  Widget build(BuildContext context)
  {
    return Row(
      children: [
        Text("⭐ $rating"),
        SizedBox(width: 8,),
        Expanded( //takes whatever space is available to expand. kinda like a flexbox in css
          child: LinearProgressIndicator(
            value: (count / _MockupUser.ratings),
            minHeight: 6,
          )
        ),
        Text("$count"),
      ],
    );
  }
}

class _Ratings extends StatelessWidget{
  final AppUser user;
  const _Ratings({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          for (int i in user.stats.ratings.keys)
            for (var count in [user.stats.ratings[i]])
              //this is the only safe way for it not to complain
              if (count is int && count >= 1)
                _RatingRow(rating: i, count: count),
                  
        ],
      ),
    );
  }
}

class _Favourite extends StatelessWidget{
  final String title, mediaType, image;
  final int rating, id;

  const _Favourite({required this.title, required this.mediaType, required this.rating, required this.image, required this.id});

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: () async {
        final media = await TmdbService().getMediaFromId(id, mediaType);
        if(context.mounted)
        {
          context.push('/info', extra: media);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 100,
              width: 70,
              child: image.isNotEmpty
                  ? Image.network(image, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace)
                    {
                      return const Icon(Icons.image_not_supported);
                    },
                    )
                  : const Icon(Icons.image_not_supported),
            ),
            SizedBox(width: 10),
            Expanded(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  Text(mediaType, style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            
            Text("⭐$rating"),
          ],
        ),
      )
    );
  }

}


class _FavouritesDisplay extends StatelessWidget {
  final AppUser user;
  const _FavouritesDisplay({required this.user});

  Future<Map<String, String>> _loadMedia(MediaStats m) {
    return TmdbService().getTitleAndPoster(m.id, m.mediaType);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (MediaStats m in user.stats.favorites)
            FutureBuilder<Map<String, String>>(
              future: _loadMedia(m),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final data = snapshot.data!;

                return _Favourite(
                  title: data['title'] ?? '',
                  mediaType: m.mediaType,
                  image: data['posterUrl'] ?? '',
                  id: m.id,
                  rating: m.score,
                );
              },
            ),
        ],
      ),
    );
  }
}