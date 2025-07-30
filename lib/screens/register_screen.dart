// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for authentication status changes to navigate after successful registration/login
    ref.listen<AuthStatus>(authProvider, (prev, next) {
      if (next == AuthStatus.authenticated) {
        // If registration leads to immediate login, navigate to home
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });

    final authStatus = ref.watch(authProvider); // To disable button while processing

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: authStatus == AuthStatus.unknown // Disable if still checking status or processing
                    ? null
                    : () async {
                  // Show a loading indicator (optional, but good UX)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registering...')),
                  );

                  final success = await ref
                      .read(authProvider.notifier)
                      .register(
                    _emailController.text,
                    _passwordController.text,
                  );

                  ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide loading indicator

                  if (success) {
                    // Already handled by ref.listen, but can add extra feedback
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registration successful!')),
                    );
                    // The ref.listen will handle navigation to /home
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registration failed. Please try again.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: authStatus == AuthStatus.unknown
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Register',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Go back to login screen
              },
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}