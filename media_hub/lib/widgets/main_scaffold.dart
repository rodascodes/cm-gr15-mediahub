import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_hub/widgets/bottom_navbar.dart';

/**
 * Scaffold principal que envolve os ecrãs da bottom nav.
 * Mantém a [CustomBottomNavBar] persistente durante a navegação entre tabs.
 */
class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  static final List<String> routes = ['/home', '/search', '/forum', '/profile'];

  /**
   * Determina o índice ativo na bottom nav com base na rota atual.
   * Usa [startsWith] para suportar sub-rotas (ex: /home/detalhes ainda marca Home).
   * Retorna 0 (Home) como fallback se a rota não corresponder a nenhuma das tabs.
   * 
   * @param location A localização/caminho da rota atual
   * @return O índice da aba ativa
   */
  int getPageLocationIndex(String location) {
    final index = routes.indexWhere((route) => location.startsWith(route));
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = getPageLocationIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: currentIndex,
        onItemTapped: (index) {
          context.go(routes[index]);
        },
      ),
    );
  }
}
