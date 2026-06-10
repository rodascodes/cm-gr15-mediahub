import 'package:flutter/material.dart';
import 'package:media_hub/utils/app_util_classes.dart';
import 'package:media_hub/controllers/auth_service.dart';
import 'package:media_hub/controllers/user_services.dart';
import 'package:media_hub/utils/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:media_hub/controllers/tmdb_service.dart';
import '../main.dart';

/**
 * Ecrã de perfil do utilizador.
 * Exibe informações pessoais, estatísticas, classificações e favoritos.
 */
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;


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

          final user = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                _Header(user: user, isDark: isDark),
                _CategorySection(user: user, isDark: isDark),
                _Ratings(user: user, isDark: isDark),
                _FavouritesDisplay(user: user, isDark: isDark),
              ],
            ),
          );
        },
      ),
    );
  }
}

/**
 * Cartão que exibe uma estatística do utilizador.
 * Mostra valor e rótulo da estatística.
 */
class _StatCard extends StatelessWidget {
  final String stat, value;
  final bool isDark;

  const _StatCard({required this.stat, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context)
  {
    return Container( //container is like using a div in html
      width: 70,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white.withValues(alpha: 0.15),
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

/**
 * Cabeçalho do perfil com informações do utilizador e botão de logout.
 */
class _Header extends StatelessWidget {
  final AppUser user;
  final bool isDark;
  
  const _Header({required this.user, required this.isDark});

  @override
  Widget build(BuildContext context)
  {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 48, 16, 16), //LTRB = Left, Top, Right, Bottom
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.profileHeaderG1, AppColors.profileHeaderG2,],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        color: isDark ? Theme.of(context).cardColor : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.logout_outlined, color: Colors.white),
                    onPressed: () {
                      AuthService().logout();
                      context.go('/login');
                    },
                  ),
                ],
              ),
            ],
          ),
          Text("@${user.username}", style: TextStyle(color: Colors.white70)),
          SizedBox(height: 16), //just to give an empty space before inserting the row with the stat cards
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              _StatCard(value: "${user.stats.totalMedia}", stat: "Ratings", isDark: isDark),
              _StatCard(value: "${user.stats.average}", stat: "Avg. Score", isDark: isDark),
              //there was no time to implement the rest
            ],
          ),
        ],
      ),
    );
  }
}

/**
 * Cartão que exibe uma categoria de média (filmes, séries, etc) com contagem.
 */
class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String mediaType;
  final int numberWatched;
  final bool isDark;

  const _CategoryCard({
    required this.icon,
    required this.mediaType,
    required this.numberWatched,
    required this.isDark,
  });



  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
          ? Theme.of(context).cardColor
          : Colors.grey.shade200,

        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.purple),
          const SizedBox(height: 8),
          Text("$numberWatched",style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black,),
          ),
          Text(mediaType),
        ],
      ),
    );
  }
}

/**
 * Seção que exibe as categorias de média do utilizador.
 */
class _CategorySection extends StatelessWidget{
  static const Map<String, IconData> icons = {
    "movie": Icons.movie,
    "tv": Icons.tv,
    "books": Icons.book,
  };

  final AppUser user;
  final bool isDark;
  const _CategorySection({required this.user, required this.isDark});

  String capitalizeString(String word)
  {
    return word[0] == 't'
                              ? '${word[0].toUpperCase()}${word.substring(1)}' //i dont want TV to be Tvs
                              : '${word[0].toUpperCase()}${word.substring(1)}s';
  }

  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, //for the text "Categories" to be centered
        children: [
          Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black,)),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 16,
                    children: [
                      for(String mediaType in user.media.keys)
                      GestureDetector(
                        onTap: () {
                          context.push('/collection', extra: 
                          {
                            'title': "${user.username}'s ${capitalizeString(mediaType)} list", 
                            'items': user.media[mediaType]
                          });
                        },
                        child: _CategoryCard(
                          icon: icons[mediaType] ?? Icons.help,
                          mediaType: mediaType[0] == 't'
                              ? '${mediaType[0].toUpperCase()}${mediaType.substring(1)}' //i dont want TV to be Tvs
                              : '${mediaType[0].toUpperCase()}${mediaType.substring(1)}s',
                          numberWatched: user.media[mediaType]?.length ?? 0,
                          isDark: isDark,
                        ),
                      ),  
                    ],
                  ),
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}

/**
 * Linha de classificação que mostra o número de médias com cada nota.
 */
class _RatingRow extends StatelessWidget{
  final int rating;
  final int count;
  final int totalRated;
  final bool isDark;
  const _RatingRow({required this.rating, required this.count, required this.totalRated, required this.isDark});

  @override
  Widget build(BuildContext context)
  {
    return Row(
      children: [
        Text("⭐ $rating"),
        SizedBox(width: 8,),
        Expanded( //takes whatever space is available to expand. kinda like a flexbox in css
          child: LinearProgressIndicator(
            value: (count / totalRated),
            minHeight: 6,
          )
        ),
        Text("$count"),
      ],
    );
  }
}

/**
 * Seção que exibe a distribuição de classificações do utilizador.
 */
class _Ratings extends StatelessWidget{
  final AppUser user;
  final bool isDark;
  const _Ratings({required this.user, required this.isDark});

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
                _RatingRow(rating: i, count: count, totalRated: user.stats.totalMedia, isDark: isDark),
                  
        ],
      ),
    );
  }
}

/**
 * Widget que exibe um item favorito com detalhes e avaliação.
 */
class _Favourite extends StatelessWidget{
  final String title, mediaType, image;
  final String? rating;
  final int id;
  final bool isDark;

  const _Favourite({required this.title, required this.mediaType, required this.rating, required this.image, required this.id, required this.isDark});

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: () async {
        final media = await TmdbService().getMediaFromId(id, mediaType.toLowerCase());
        if(context.mounted)
        {
          context.push('/info', extra: media);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).cardColor : Colors.purple.shade50,
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
                  Text(mediaType, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87,)),
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
  final bool isDark;
  const _FavouritesDisplay({required this.user, required this.isDark});

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
                  mediaType: '${m.mediaType[0].toUpperCase()}${m.mediaType.substring(1)}',
                  image: data['posterUrl'] ?? '',
                  id: m.id,
                  rating: m.score.toString(),
                  isDark: isDark,
                );
              },
            ),
        ],
      ),
    );
  }
}