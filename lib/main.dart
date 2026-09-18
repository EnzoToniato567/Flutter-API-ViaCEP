import 'package:flutter/material.dart';

import 'ui/home.dart';
import 'ui/splash.dart';
import 'ui/style/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verde CEP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.tema,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
