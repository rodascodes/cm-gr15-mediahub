
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_hub/utils/app_util_classes.dart';
import 'package:media_hub/controllers/tmdb_service.dart';

/**
 * Página que exibe uma lista de média do utilizador.
 * Mostra detalhes como título, cartaz e avaliação.
 */
class UserList extends StatefulWidget {
  final String title;
  final Map<String, MediaStats> mediaStatsList;
  
  const UserList({super.key, required this.title, required this.mediaStatsList});

  @override
  State<StatefulWidget> createState() => UserListState();
}

/**
 * Estado da página de lista do utilizador.
 * Carrega e exibe média com suas respectivas avaliações.
 */
class UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: FutureBuilder(
              future: TmdbService().getMediaListFromMediaStatsList(widget.mediaStatsList.values.toList()),
              builder: (context, asyncSnapshot) 
              {
                if(asyncSnapshot.hasData)
                {
                  return ListView(
                    padding: const EdgeInsets.all(8),
                    children: asyncSnapshot.requireData.map((movie)
                    {
                      final stats = widget.mediaStatsList[movie.id.toString()]!;

                      return GestureDetector(
                        onTap: () {
                          context.push("/info", extra: movie);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [

                              SizedBox(
                                height: 100,
                                width: 70,
                                //if the path is empty it doesn't explode, simply provides image not supported
                                child: movie.posterPath.isNotEmpty
                                    ? Image.network(
                                        "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.image_not_supported),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

                                    const SizedBox(height: 4),

                                    Text(movie.type, style: const TextStyle(color: Colors.grey)),

                                    const SizedBox(height: 4),

                                    Text(
                                      "Added on: ${stats.addedAt!.day}/${stats.addedAt!.month}/${stats.addedAt!.year}",
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),

                              Text("⭐ ${stats.score}", style: const TextStyle(fontWeight: FontWeight.bold,),),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            )
          ),
        ],
      ),
    );
  }
}