import 'package:flutter/material.dart';

import 'style/colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _visivel = false;

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;
    setState(() => _visivel = true);
  }

  Future<void> _entrar() async {
    setState(() => _visivel = false);
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.verdeEscuro,
      body: Center(
        child: AnimatedOpacity(
          opacity: _visivel ? 1 : 0,
          duration: const Duration(milliseconds: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Image.asset('assets/icon.png'),
              ),
              const SizedBox(height: 20),
              const Text(
                'VERDE CEP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Cadastro de pessoas e endereços',
                style: TextStyle(color: AppColors.verdeClaro),
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _visivel ? _entrar : null,
                icon: const Icon(Icons.login, size: 20),
                label: const Text('Entar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
