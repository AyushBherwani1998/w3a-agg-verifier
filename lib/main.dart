import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:w3a_custom_auth/home_screen.dart';
import 'package:w3a_custom_auth/login_screen.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

Future<void> main() async {
  const cliendId =
      "BPi5PB_UiIZ-cPz1GtV5i1I2iOSOHuimiXBI0e-Oe_u6X3oVAbCiAZOTEBtTXw4tsluTITPqA8zMsfxIKMjiqNQ";

  WidgetsFlutterBinding.ensureInitialized();
  final Uri redirectUrl;

  if (Platform.isAndroid) {
    redirectUrl = Uri.parse(
      'w3a://com.example.w3a_custom_auth/auth',
    );
  } else {
    redirectUrl = Uri.parse('com.example.w3acustomauth://auth');
  }

  final loginConfig = HashMap<String, LoginConfigItem>();
 
  loginConfig['google'] = LoginConfigItem(
    verifier: "mocaverse-agg-verifier",
    verifierSubIdentifier: "google",
    typeOfLogin: TypeOfLogin.google,
    clientId:
        "519228911939-cri01h55lsjbsia1k7ll6qpalrus75ps.apps.googleusercontent.com",
  );
  
  loginConfig['jwt'] = LoginConfigItem(
    verifier: "mocaverse-agg-verifier",
    verifierSubIdentifier: "email-passwordless",
    typeOfLogin: TypeOfLogin.jwt,
    clientId: "hUVVf4SEsZT7syOiL0gLU9hFEtm2gQ6O",
  );

  await Web3AuthFlutter.init(
    Web3AuthOptions(
      clientId: cliendId,
      network: Network.sapphire_mainnet,
      redirectUrl: redirectUrl,
      loginConfig: loginConfig,
      sdkUrl: "https://auth.mocaverse.xyz",
      walletSdkUrl: "https://lrc-mocaverse.web3auth.io",
    ),
  );

  await Web3AuthFlutter.initialize();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final Future<Web3AuthResponse> web3AuthResponseFuture;
  @override
  void initState() {
    super.initState();
    web3AuthResponseFuture = Web3AuthFlutter.getWeb3AuthResponse();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<Web3AuthResponse>(
        future: web3AuthResponseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final pubKey = snapshot.data!.tssPubKey;
              if (pubKey != null && pubKey.isNotEmpty) {
                return const HomeScreen();
              }
            }
            return const LoginScreen();
          }
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
    );
  }
}
