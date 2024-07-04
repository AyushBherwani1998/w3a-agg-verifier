import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:w3a_custom_auth/core/widgets/custom_dialog.dart';
import 'package:w3a_custom_auth/login_screen.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';
import 'package:web3dart/crypto.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ValueNotifier<bool> isAccountLoaded;
  late final String address;

  late double balance;
  late final dynamic web3AuthInfo;

  @override
  void initState() {
    super.initState();
    isAccountLoaded = ValueNotifier<bool>(false);
    loadAccount(context);
  }

  Future<void> loadAccount(BuildContext context) async {
    try {
      final response = await Web3AuthFlutter.getWeb3AuthResponse();
      final tssPubKey = response.tssPubKey!;

      address = bytesToHex(
        publicKeyToAddress(base64Decode(tssPubKey)),
        include0x: true,
      );
      isAccountLoaded.value = true;
      log(address);
    } catch (e, _) {
      log(e.toString(), stackTrace: _);
      if (context.mounted) {
        showInfoDialog(context, e.toString());
      }
    }
  }

  Widget get verticalGap => const SizedBox(height: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            logOut(context);
          },
        ),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: isAccountLoaded,
        builder: (context, isLoaded, _) {
          if (isLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    address,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => _launchWalletServices(),
                    child: const Text("Lauch Wallet Services"),
                  )
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator.adaptive());
        },
      ),
    );
  }

  Future<void> _launchWalletServices() async {
    final chainConifg = ChainConfig(
      chainId: "0x89",
      rpcTarget: "https://polygon.llamarpc.com",
    );
    await Web3AuthFlutter.launchWalletServices(chainConifg);
  }

  Future<void> logOut(BuildContext context) async {
    showLoader(context);

    try {
      await Web3AuthFlutter.logout();
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return const LoginScreen();
          }),
        );
      }
    } catch (e, _) {
      if (context.mounted) {
        removeDialog(context);
        showInfoDialog(context, e.toString());
      }
    }
  }
}
