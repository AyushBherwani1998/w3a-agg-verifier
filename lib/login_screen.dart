import 'package:flutter/material.dart';
import 'package:w3a_custom_auth/home_screen.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

import 'core/widgets/custom_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController textEditingController;
  late final GlobalKey<FormState> formKey;

  Widget get verticalGap => const SizedBox(height: 16);

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Web3Auth CustomAuth Sample",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              verticalGap,
              OutlinedButton(
                onPressed: () => _loginWithEmailPasswordless(
                  context,
                  Provider.email_passwordless,
                ),
                child: const Text("Login with Email passwordless"),
              ),
              verticalGap,
              OutlinedButton(
                onPressed: () => _loginWithGoogle(context, Provider.google),
                child: const Text("Login with Google"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToHomeScree(BuildContext context) {
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) {
          return const HomeScreen();
        }),
      );
    }
  }

  Future<void> _loginWithEmailPasswordless(
    BuildContext context,
    Provider loginProvider,
  ) async {
    try {
      await Web3AuthFlutter.login(
        LoginParams(
          loginProvider: Provider.jwt,
          extraLoginOptions: ExtraLoginOptions(
            domain: 'https://web3auth.au.auth0.com',
            verifierIdField: 'email',
            // connection: 'email',
          ),
        ),
      );

      if (context.mounted) {
        _navigateToHomeScree(context);
      }
    } catch (e, _) {
      if (context.mounted) {
        showInfoDialog(context, e.toString());
      }
    }
  }

  Future<void> _loginWithGoogle(
    BuildContext context,
    Provider loginProvider,
  ) async {
    try {
      await Web3AuthFlutter.login(
        LoginParams(loginProvider: Provider.google),
      );

      if (context.mounted) {
        _navigateToHomeScree(context);
      }
    } catch (e, _) {
      if (context.mounted) {
        showInfoDialog(context, e.toString());
      }
    }
  }
}
