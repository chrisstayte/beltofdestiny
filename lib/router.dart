import 'package:beltofdestiny/screens/credits_screen.dart';
import 'package:beltofdestiny/screens/game/game_root.dart';
import 'package:beltofdestiny/screens/main_menu_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';

final router = GoRouter(
  // initialLocation: kDebugMode ? '/game' : '/',
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenuScreen(
        key: Key('main_menu_screen'),
      ),
      routes: [
        GoRoute(
          path: 'game',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const GameRoot(
              key: Key('game_screen'),
            ),
            transitionDuration: const Duration(milliseconds: 1050),
            reverseTransitionDuration: const Duration(milliseconds: 1050),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    NesVerticalCloseTransition(
              animation: animation,
              child: child,
            ),
          ),
        ),
        GoRoute(
          path: 'credits',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const CreditsScreen(
              key: Key('credits_screen'),
            ),
            transitionDuration: const Duration(milliseconds: 1050),
            reverseTransitionDuration: const Duration(milliseconds: 1050),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    NesHorizontalGridTransition(
              animation: animation,
              child: child,
            ),
          ),
        ),
      ],
    ),
  ],
);
