// lib/main.dart (excerpt)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart'; // <--- NEW IMPORT
import 'screens/flashcard_list_screen.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(authProvider);

    Widget initialScreen;
    if (authStatus == AuthStatus.authenticated) {
      initialScreen = const FlashcardListScreen();
    } else if (authStatus == AuthStatus.unauthenticated) {
      initialScreen = LoginScreen();
    } else {
      initialScreen = const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return MaterialApp(
      title: 'Flashcard App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: initialScreen,
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(), // <--- ADD THIS ROUTE
        '/home': (context) => const FlashcardListScreen(),
      },
    );
  }
}