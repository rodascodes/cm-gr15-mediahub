import 'package:flutter/material.dart';

class MoviePage extends StatelessWidget {
  const MoviePage({super.key});

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

                  const Icon(Icons.arrow_back, color: Colors.white),

                  const SizedBox(height: 20),

                  Row(
                    children: [

                      Container(
                        width: 70,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.movie, size: 40),
                      ),

                      const SizedBox(width: 10),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [

                          Text(
                            "Dune: Part Two",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            "2024 • Sci-Fi, Adventure",
                            style: TextStyle(color: Colors.white70),
                          ),

                          SizedBox(height: 5),

                          Text(
                            "⭐ 8.9 (12 453)",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Paul Atreides une-se a Chani e aos Fremen enquanto procura vingança contra os conspiradores que destruíram a sua família.",
                    style: TextStyle(color: Colors.white),
                  )
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(10, (index) {
                    return Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text("${index + 1}"),
                    );
                  }),
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

                // COMMENT 1
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      CircleAvatar(child: Icon(Icons.person)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Obra-prima absoluta! A cinematografia é de outro nível.",
                        ),
                      ),
                      Text("⭐10")
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // COMMENT 2
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      CircleAvatar(child: Icon(Icons.person)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Excelente continuação. A banda sonora é épica!",
                        ),
                      ),
                      Text("⭐9")
                    ],
                  ),
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

                CircleAvatar(
                  backgroundColor: Colors.purple,
                  child: const Icon(Icons.send, color: Colors.white),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}