
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_hub/app_util_classes.dart';
import 'package:media_hub/util/tmdb_service.dart';

class UserList extends StatefulWidget {
  final String title;
  //final List<MediaStats> mediaStatsList;
  final Map<String, MediaStats> mediaStatsList;
  
  const UserList({super.key, required this.title, required this.mediaStatsList});

  @override
  State<StatefulWidget> createState() => UserListState();
}

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
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: GestureDetector(
                          onTap: () {
                            context.push("/info", extra: movie);
                          },
                          child: ListTile(
                            leading: Image.network(
                              "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                              width: 50,
                              height: 75,
                              fit: BoxFit.cover,
                            ),
                            title: Text(movie.title),
                            subtitle: Text('${widget.mediaStatsList[movie.id.toString()]!.addedAt} - Rating: ${widget.mediaStatsList[movie.id.toString()]!.score}'),
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