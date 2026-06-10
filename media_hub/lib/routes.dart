import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_hub/app_util_classes.dart';
import 'package:media_hub/bottom_nav/forum_screen.dart';
import 'package:media_hub/bottom_nav/home_screen.dart';
import 'package:media_hub/bottom_nav/profile_screen.dart';
import 'package:media_hub/bottom_nav/search_screen.dart';
import 'package:media_hub/login.dart';
import 'package:media_hub/main_scaffold.dart';
import 'package:media_hub/page_info.dart';
import 'package:media_hub/profile_pages/user_list.dart';
import 'package:media_hub/register.dart';
import 'package:media_hub/services/auth_service.dart';
import 'package:media_hub/util/mediacard.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AuthService().currentUser == null ? '/login' : '/home',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: '/search',
          name: 'search',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const SearchPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ), 
        GoRoute(
          path: '/forum',
          name: 'forum',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: ForumPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ), 
        GoRoute(
          path: '/profile',
          name: 'profile',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: ProfileScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: '/info',
      name: 'info',
      builder: (context, state) {
        final media = state.extra as Media;

        return MoviePage(media: media);
      },
    ),

    GoRoute
    (
      path: '/collection',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        return UserList(
          title: data['title'],
          mediaStatsList: (data['items'] as Map<String, MediaStats>),
        );
      },
    ),
  ],
);