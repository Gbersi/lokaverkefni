import 'package:spilakvold/screens/main_menu.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart'; // new
import 'package:flutter/material.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
              GoogleProvider(clientId: "742643561051-vkks7ri9lhlh8bi2mijat1vr55k9dv29.apps.googleusercontent.com"),  // new
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    'https://www.shutterstock.com/image-illustration/cyber-security-concept-type-password-260nw-1274162341.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                  ),
                ),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                    ? const Text('velkomin í spilakvöld, vinsamlegast skráðu þig inn!')
                    : const Text('velkomin í spilakvöld, vinsamlegast skráðu þig inn!'),
              );
            },
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'By signing in, you agree to our terms and conditions.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
            sideBuilder: (context, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    'data:image/png;base64,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',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                  ),
                ),
              );
            },
          );
        }

        return const MainMenu();
      },
    );
  }
}
