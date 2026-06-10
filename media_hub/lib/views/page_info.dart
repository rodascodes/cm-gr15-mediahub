import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_hub/utils/mediacard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:media_hub/controllers/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:media_hub/controllers/notification_service.dart';


/**
 * Representa um comentário de um utilizador sobre um filme ou série.
 * Contém informações do autor, texto do comentário, avaliação e data.
 */
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

/**
 * Widget que apresenta a página de detalhes de um filme ou série.
 * Permite visualizar informações, adicionar classificações, comentários e marcar como favorito.
 */
class MoviePage extends StatefulWidget {
  final Media media;

  const MoviePage({
    super.key,
    required this.media,
  });

  @override
  State<MoviePage> createState() => _MoviePageState();
}

/**
 * Estado da página de detalhes do filme.
 * Gerencia classificações, favoritos, comentários e interações com Firestore.
 */
class _MoviePageState extends State<MoviePage> {
  int? selectedRating;
  bool? favorite;

  @override
  void initState() {
    super.initState();
    loadUserRating();
    loadFavorite();
  }

  /**
   * Converte o tipo de mídia para o formato correto usado no Firestore.
   * Normaliza variações como "TV", "TV Show", "Movie", etc.
   * 
   * @param type O tipo de mídia a ser corrigido
   * @return O tipo de mídia normalizado em minúsculas
   */
  String correctType(String type)
  {
    if(type.toLowerCase().startsWith("t") && type.length >= 3)
    {
      //because the way the media cards are coded the type can be stored as "Tv"; "Tv Show"; or even "Tv Show 3489 comments", and this breaks the programs flow when consulting firestore
      type = type.toLowerCase().substring(0, 2).trim();
    }
    else if(type.toLowerCase().startsWith('m') && type.length >= 6)
    {
      type = type.toLowerCase().substring(0, 5);
    }
    return type.toLowerCase();
  }

  /**
   * Carrega a classificação do utilizador para o filme/série atual do Firestore.
   * Atualiza o estado com a classificação encontrada.
   */
  Future<void> loadUserRating() async {
    final uid = AuthService().currentUid;

    if (uid == null) return;

    String type = correctType(widget.media.type);

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

  /**
   * Guarda a classificação do utilizador no Firestore.
   * Também atualiza a coleção de mídia do utilizador e exibe uma notificação.
   * 
   * @param rating A classificação a guardar (1-10)
   */
  Future<void> saveRating(int rating) async {
    final uid = AuthService().currentUid;

    if (uid == null) return;

    String type = correctType(widget.media.type);
    

    //saves that this user has this kind of media in his collection (ex: if its a movie then the user has movies)
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
        'collections': FieldValue.arrayUnion([type])
    }, SetOptions(merge: true));

    //saves the actual info
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(type)
        .doc(widget.media.id.toString())
        .set({
      'score': rating,
      'favorite': favorite,
      'updatedAt': Timestamp.now(),
      'mediaType': type,
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

  /**
   * Carrega o estado de favorito do filme/série do Firestore.
   * Atualiza o estado com o valor encontrado ou define como não favorito se não existir.
   */
  Future<void> loadFavorite() async
  {
    final uid = AuthService().currentUid;

    String type = correctType(widget.media.type);

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
  }

  /**
   * Alterna o estado de favorito do filme/série e guarda no Firestore.
   * Exibe uma notificação informando o utilizador sobre a ação realizada.
   */
  Future<void> toggleFavorite() async
  {
    final uid = AuthService().currentUid;

    if (uid == null) return;

    String type = correctType(widget.media.type);

    bool isFavorite = !favorite!;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
        'collections': FieldValue.arrayUnion([type])
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(type)
        .doc(widget.media.id.toString())
        .set({
      'score': selectedRating,
      'favorite': isFavorite,
      'updatedAt': Timestamp.now(),
      'mediaType': type,
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

  /// Lista de comentários adicionados ao filme/série
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

  /**
   * Adiciona um novo comentário à lista de comentários.
   * Valida que o comentário não está vazio e exibe uma notificação de sucesso.
   */
  void addComment() {
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

  /**
   * Constrói a interface da página de detalhes do filme/série.
   * Apresenta informações, galeria de imagens, classificação, favoritos e comentários.
   */
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