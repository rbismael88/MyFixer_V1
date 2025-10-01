
import 'dart:async';
import 'package:flutter/material.dart';

class FindingProviderScreen extends StatefulWidget {
  const FindingProviderScreen({super.key});

  @override
  State<FindingProviderScreen> createState() => _FindingProviderScreenState();
}

class _FindingProviderScreenState extends State<FindingProviderScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay for finding a provider
    Timer(const Duration(seconds: 3), () {
      // For now, just pop the screen. Later, navigate to a provider found screen.
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 24),
            const Text(
              'Buscando un proveedor...',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
