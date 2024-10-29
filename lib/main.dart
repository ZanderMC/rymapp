import 'package:aymapp/models/character_model.dart';
import 'package:aymapp/providers/api_provider.dart';
import 'package:aymapp/screens/character_screen.dart';
import 'package:aymapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => ApiProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(initialLocation: '/', routes: [
        GoRoute(
          path: "/",
          builder: (context, state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: "/CharacterScreen",
          builder: (context, state) {
            final character = state.extra as Character;
            return CharacterScreen(
              character: character,
            );
          },
        )
      ]),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
    );
  }
}
