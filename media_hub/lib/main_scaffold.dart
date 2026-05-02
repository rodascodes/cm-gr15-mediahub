import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_hub/bottom_navbar.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  static final List<String> routes = ['/home', '/search', '/forum', '/profile'];

  int getPageLocationIndex(String location) {
    final index = routes.indexWhere((route) => location.startsWith(route));
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final location =
        GoRouter.of(context).routeInformationProvider.value.uri.path;
    final currentIndex = getPageLocationIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: currentIndex,
        onItemTapped: (index) {
          context.push(routes[ //push is better than go cause with push we can go back :)
              index]);
        },
      ),
    );
  }
}
