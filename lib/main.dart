import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'repositories/auth_repository.dart';
import 'screens/busca_screen.dart';
import 'screens/dobradura_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(AuthRepository()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App Dobraduras',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => HomeScreen(),
          '/dobradura': (context) => DobraduraScreen(),
          '/login': (context) => const LoginScreen(),
          '/busca': (context) => const BuscaScreen(),
        },
      ),
    );
  }
}
