// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(authProvider);

    // Listen for auth status changes to navigate
    ref.listen<AuthStatus>(authProvider, (prev, next) {
      if (next == AuthStatus.authenticated) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: authStatus == AuthStatus.unknown // Disable if still checking status
                  ? null
                  : () async {
                final success = await ref
                    .read(authProvider.notifier)
                    .login(_emailController.text, _passwordController.text);
                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login failed. Please check credentials.')),
                  );
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to registration screen
                Navigator.of(context).pushNamed('/register');
              },
              child: const Text('Don\'t have an account? Register'),
            ),
            if (authStatus == AuthStatus.unknown)
              const CircularProgressIndicator(), // Show loading on startup check
          ],
        ),
      ),
    );
  }
}