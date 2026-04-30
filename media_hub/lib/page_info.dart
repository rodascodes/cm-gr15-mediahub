import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MoviePage(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class MoviePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.orange,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Icon(Icons.arrow_back, color: Colors.white),

                  SizedBox(height: 20),

                  Row(
                    children: [

                      Container(
                        width: 70,
                        height: 90,
                        color: Colors.orangeAccent,
                        child: Icon(Icons.movie),
                      ),

                      SizedBox(width: 10),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            "Dune: Part Two",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            "2024 • Sci-Fi",
                            style: TextStyle(color: Colors.white70),
                          ),

                          SizedBox(height: 5),

                          Text(
                            "⭐ 8.9",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Paul Atreides une-se aos Fremen para lutar contra os inimigos.",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [

                Text("Dê a sua classificação"),

                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(10, (index) {
                    return Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      color: Colors.grey[300],
                      child: Text("${index + 1}"),
                    );
                  }),
                ),

                SizedBox(height: 20),

                Text("Comentários"),

                SizedBox(height: 10),

                Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.grey[200],
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 10),
                      Expanded(child: Text("Obra-prima absoluta!")),
                      Text("10")
                    ],
                  ),
                ),

                SizedBox(height: 10),

                Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.grey[200],
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 10),
                      Expanded(child: Text("Excelente continuação")),
                      Text("9")
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}