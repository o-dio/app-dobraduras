import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/dobradura_provider.dart';
import 'repositories/auth_repository.dart';
import 'repositories/dobradura_repository.dart';
import 'screens/busca_screen.dart';
import 'screens/dobradura_form_screen.dart';
import 'screens/dobradura_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => DobraduraProvider(DobraduraRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App Dobraduras',
        // Permite arrastar/puxar com mouse e trackpad na Web (inclusive para RefreshIndicator e carrosséis)
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
          },
        ),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
               seedColor: Color(0xFFD6AF55),
              ).copyWith(
              primary: Color(0xFF355C75),
              secondary: Color(0xFF6D8797),
              tertiary: Color(0xFFC49A3A),

              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onTertiary: Color(0xFF6D8797),
          ), 
          scaffoldBackgroundColor: Color(0xFFF5F3EB),
          useMaterial3: true,
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => const HomeScreen(),
          '/dobradura': (context) => const DobraduraScreen(),
          '/login': (context) => const LoginScreen(),
          '/busca': (context) => const BuscaScreen(),
          '/admin/dobradura': (context) => const DobraduraFormScreen(),
        },
      ),
    );
  }
}
