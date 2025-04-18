import 'package:flutter/material.dart';
import 'package:startup_navigation/features/welcome/presentation/pages/welcome_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StartupNavigationApp());
}

class StartupNavigationApp extends StatelessWidget {
  const StartupNavigationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '창업 네비게이션',
      home: const WelcomePage(),
    );
  }
}
