import 'package:flutter/material.dart';
import 'package:media_hub/util/app_colors.dart';
import 'package:go_router/go_router.dart';

class _MockupUser {
  static String name = "João Silva";
  static String username = "joaosilva";
  static int ratings = 247;
  static double average = 7.8;
  static int hours = 156;
  static int top = 5;
  static Map<String, int> mediaTypes = {"Movies" : 89, "TV Shows" : 124, "Books" : 34};
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
  const _Header();

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
              Text(_MockupUser.name, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              Icon(Icons.settings, color: Colors.white),
            ],
          ),
          Text("@${_MockupUser.username}", style: TextStyle(color: Colors.white70)),
          SizedBox(height: 16), //just to give an empty space before inserting the row with the stat cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatCard(value: "${_MockupUser.ratings}", stat: "Ratings"),
              _StatCard(value: "${_MockupUser.average}", stat: "Avg. Score"),
              _StatCard(value: "${_MockupUser.hours}h", stat: "Time"),
              _StatCard(value: "Top ${_MockupUser.top}%", stat: ""),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget{
  final IconData icon;
  final String mediaType;
  final int numberWatched;

  const _CategoryCard({required this.icon, required this.mediaType, required this.numberWatched});

  @override
  Widget build(BuildContext context)
  {
    return Container(
      width: 100,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.purple,),
          SizedBox(height: 8,),
          Text("$numberWatched", style: TextStyle(fontWeight: FontWeight.bold),),
          Text(mediaType),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget{
  static const Map<String, IconData> icons = {
    "Movies": Icons.movie,
    "TV Shows": Icons.tv,
    "Books": Icons.book,
  };
  const _CategorySection();

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for(String mediaType in _MockupUser.mediaTypes.keys)
                _CategoryCard(icon: icons[mediaType] ?? Icons.help, mediaType: mediaType, numberWatched: _MockupUser.mediaTypes[mediaType] ?? 0) //in flutter ?? means if there is not any then do this instead
            ],
          ),
        ],
      ),
    );
  }
}

//DUE TO TIME CONSTRAINTS, FROM HERE ON OUT THINGS WILL BE HARD CODED JUST TO SHOW HOW IT WOULD LOOK LIKE.
//after getting data from a database things will no longer be hardcoded (will be using something like the MockupUser being used above)
//but for now this will do

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
  const _Ratings();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _RatingRow(rating: 10, count: 45),
          _RatingRow(rating: 9, count: 62),
          _RatingRow(rating: 8, count: 71),
          _RatingRow(rating: 7, count: 38),
          _RatingRow(rating: 6, count: 19),
          _RatingRow(rating: 5, count: 12),
        ],
      ),
    );
  }
}

class _Favourite extends StatelessWidget{
  final String title, mediaType;
  final int rating;

  const _Favourite({required this.title, required this.mediaType, required this.rating});

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: () => context.push('/info'),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SizedBox(height: 100, width: 50, child: Image.network("https://cdn.nos.pt/cinemas/movies/files/700x1000/ad6c2d27-24a4-4736-a31c-aa2b9826cbdc_Image.jpg"),),
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

class _FavouritesDisplay extends StatelessWidget{
  const _FavouritesDisplay();

  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: [
        _Favourite(title: "El Projeto Ave Maria", mediaType: "Movie", rating: 10),
        _Favourite(title: "El Projeto Ave Maria 2", mediaType: "Movie", rating: 10),
        _Favourite(title: "El Projeto Ave Maria: El Seriado de Netflix", mediaType: "Tv Show", rating: 10),
      ],
    );
  }
}

class ProfileScreen extends StatelessWidget{
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Header(),
            _CategorySection(),
            _Ratings(),
            _FavouritesDisplay(),
          ],
        ),
      ),
    );
  }
}