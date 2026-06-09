import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_hub/app_util_classes.dart';
import 'package:media_hub/util/mediacard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:media_hub/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:media_hub/services/notification_service.dart';


class MovieComment {
  final String username;
  final String comment;
  final int? rating;
  final DateTime date;

  MovieComment({
    required this.username,
    required this.comment,
    this.rating,
    required this.date,
  });
}


class MoviePage extends StatefulWidget {
  final Media media;

  const MoviePage({
    super.key,
    required this.media,
  });

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  int? selectedRating;
  bool? favorite;

  @override
  void initState() {
    super.initState();
    loadUserRating();
    loadFavorite();
    print('el tipo es${widget.media.type}');
  }

  Future<void> loadUserRating() async {
    final uid = AuthService().currentUid;

    String type = widget.media.type;
      print('el tipo es${widget.media.type}');


    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(type.toLowerCase())
        .doc(widget.media.id.toString())
        .get();

    if (doc.exists && doc['score'] != null) {
      setState(() {
        selectedRating = doc['score'];
      });
    }
  }

  Future<void> saveRating(int rating) async {
    final uid = AuthService().currentUid;

    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
        'collections': FieldValue.arrayUnion(['${widget.media.type.toLowerCase()}'])
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(widget.media.type.toLowerCase())
        .doc(widget.media.id.toString())
        .set({
      'score': rating,
      'favorite': favorite,
      'updatedAt': Timestamp.now(),
      'mediaType': widget.media.type.toLowerCase(),
      //'collections': FieldValue.arrayUnion(['${widget.media.type}']),
    }, SetOptions(merge: true));

    setState(() {
      selectedRating = rating;
    });

    await NotificationService.showNotification(
      title: 'Avaliação Guardada',
      body: 'A sua nota para ${widget.media.title} foi guardada.',
    );
  }

  Future<void> loadFavorite() async
  {
    final uid = AuthService().currentUid;

    String type = widget.media.type;

    print("intializing favorite");


    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(type.toLowerCase())
        .doc(widget.media.id.toString())
        .get();

    if (doc.exists) {
      setState(() {
        favorite = doc['favorite'] ?? false;
        
      });
    }
    else {
      favorite = false;
    }
    print("So, was it favorite? $favorite");
  }

  Future<void> toggleFavorite() async
  {
    final uid = AuthService().currentUid;

    if (uid == null) return;

    bool isFavorite = !favorite!;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
        'collections': FieldValue.arrayUnion(['${widget.media.type.toLowerCase()}'])
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(widget.media.type.toLowerCase())
        .doc(widget.media.id.toString())
        .set({
      'score': selectedRating,
      'favorite': isFavorite,
      'updatedAt': Timestamp.now(),
      'mediaType': widget.media.type.toLowerCase(),
    }, SetOptions(merge: true));

    setState(() {
      favorite = isFavorite;
    });

    await NotificationService.showNotification(
      title: "${isFavorite ? "Adicionado aos" : "Removido dos"} favoritos!",
      body: "${widget.media.title} foi ${isFavorite ? "adicionado aos favoritos" : "removido dos favoritos"} com sucesso."
    );
  }




  final TextEditingController _commentController = TextEditingController();

  List<MovieComment> comments = [
    MovieComment(
      username: "Pedro",
      comment: "Obra-prima absoluta! A cinematografia é incrível.",
      rating: 10,
      date: DateTime.now().subtract(const Duration(hours: 2)),
    ),

    MovieComment(
      username: "Joana",
      comment: "Excelente continuação. Banda sonora fantástica.",
      rating: 9,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];



  void addComment() {
    print("ENTREI NO ADD COMMENT");
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      comments.insert(
        0,
        MovieComment(
          username: FirebaseAuth.instance.currentUser?.displayName ?? FirebaseAuth.instance.currentUser?.email ?? "Utilizador",
          comment: _commentController.text.trim(),
          rating: selectedRating,
          date: DateTime.now(),
        ),
      );
    });

    _commentController.clear();

    NotificationService.showNotification(
      title: 'Comentário Enviado',
      body: 'O seu comentário foi adicionado com sucesso.',
  );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFB300), Color(0xFFFF6F00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "https://image.tmdb.org/t/p/w500${widget.media.posterPath}",
                          width: 120,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              widget.media.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              widget.media.releaseDate,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "⭐ ${widget.media.rating.toStringAsFixed(1)}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              widget.media.overview,
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                          ],
                        )
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // SCROLL CONTENT
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [

                const Text(
                  "Dê a Sua Classificação",
                  style: TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 10),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(10, (index) {
                    final value = index + 1;

                    return GestureDetector(
                      onTap: () {
                        saveRating(value);
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selectedRating == value
                              ? Colors.amber
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$value',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: selectedRating == value
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }),
                ),

        
                Row(
                  children: [
                    Text('Marcar como favorito: ', style: TextStyle(fontSize: 18)),
                    Checkbox(value: favorite ?? false, onChanged: (_) => toggleFavorite())
                  ],
                ),

                const SizedBox(height: 25),

                const Text(
                  "Comentários (3)",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [

                              Expanded(
                                child: Row(
                                  children: [

                                    Text(
                                      comment.username,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    if (comment.rating != null) ...[
                                      const SizedBox(width: 8),

                                      Text(
                                        "⭐ ${comment.rating}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]
                                  ],
                                ),
                              ),

                              Text(
                                "${comment.date.day.toString().padLeft(2, '0')}/"
                                "${comment.date.month.toString().padLeft(2, '0')}/"
                                "${comment.date.year} "
                                "${comment.date.hour.toString().padLeft(2, '0')}:"
                                "${comment.date.minute.toString().padLeft(2, '0')}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Text(comment.comment),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 80), // espaço para o input
              ],
            ),
          ),

          // COMMENT INPUT
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black12,
                )
              ],
            ),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Adicione um comentário...",
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                GestureDetector(
                  onTap: addComment,
                  child: const CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}