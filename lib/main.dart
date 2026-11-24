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

    final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFFD6AF55),
  ).copyWith(
    primary: const Color(0xFF355C75),
    secondary: const Color(0xFF6D8797),
    tertiary: const Color(0xFFC49A3A),

    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onTertiary: const Color(0xFF292820),

    surface: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFF292820),
  );

  // TIPOGRAFIA GLOBAL

  final baseTextTheme = ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
  ).textTheme;

  final textTheme = baseTextTheme.copyWith(
    // Títulos principais
    headlineLarge: baseTextTheme.headlineLarge?.copyWith(
      color: colorScheme.primary,
      fontWeight: FontWeight.bold,
    ),

    headlineMedium: baseTextTheme.headlineMedium?.copyWith(
      color: colorScheme.primary,
      fontWeight: FontWeight.bold,
    ),

    // Títulos de seções
    titleLarge: baseTextTheme.titleLarge?.copyWith(
      color: colorScheme.primary,
      fontWeight: FontWeight.bold,
    ),

    titleMedium: baseTextTheme.titleMedium?.copyWith(
      color: colorScheme.primary,
      fontWeight: FontWeight.w600,
    ),

    // Textos
    bodyLarge: baseTextTheme.bodyLarge?.copyWith(
      color: const Color.fromARGB(255, 255, 255, 255),
    ),

    bodyMedium: baseTextTheme.bodyMedium?.copyWith(
      color: const Color(0xFF45443F),
    ),

    bodySmall: baseTextTheme.bodySmall?.copyWith(
      color: const Color(0xFF77746D),
    ),

    // Textos de botões
    labelLarge: baseTextTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
    ),
  );

  // Formato padrão dos botões
  final buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  );

  // 3. TEMA GLOBAL DOS COMPONENTES

  final appTheme = ThemeData(
    useMaterial3: true,

    colorScheme: colorScheme,
    textTheme: textTheme,

    // Fundo das telas
    scaffoldBackgroundColor: const Color(0xFFF5F3EB),

    // Ícones gerais
    iconTheme: IconThemeData(
      color: colorScheme.primary,
    ),

    // APP BAR

    appBarTheme: AppBarThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,

      titleTextStyle: baseTextTheme.titleLarge?.copyWith(
        color: colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
      ),

      iconTheme: IconThemeData(
        color: colorScheme.onPrimary,
      ),
    ),

    // ------------------------------------------
    // ELEVATED BUTTON
    // ------------------------------------------

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        shape: buttonShape,
        textStyle: textTheme.labelLarge,
        elevation: 0,
      ),
    ),

    // ------------------------------------------
    // FILLED BUTTON
    // ------------------------------------------

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        shape: buttonShape,
        textStyle: textTheme.labelLarge,
      ),
    ),

    // ------------------------------------------
    // OUTLINED BUTTON
    // ------------------------------------------

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(
          color: colorScheme.secondary,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        shape: buttonShape,
        textStyle: textTheme.labelLarge,
      ),
    ),

    // ------------------------------------------
    // TEXT BUTTON
    // ------------------------------------------

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        textStyle: textTheme.labelLarge,
      ),
    ),

    // ------------------------------------------
    // CARTÕES
    // ------------------------------------------

    cardTheme: CardThemeData(
      color: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),

    // ------------------------------------------
    // CAMPOS DE TEXTO
    // ------------------------------------------

    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: colorScheme.surface,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: 2,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.error,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.error,
          width: 2,
        ),
      ),

      labelStyle: TextStyle(
        color: colorScheme.onSurfaceVariant,
      ),

      hintStyle: TextStyle(
        color: colorScheme.onSurfaceVariant,
      ),
    ),

    // ------------------------------------------
    // BOTÃO FLUTUANTE
    // ------------------------------------------

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.tertiary,
      foregroundColor: colorScheme.onTertiary,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // ------------------------------------------
    // INDICADORES DE CARREGAMENTO
    // ------------------------------------------

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: colorScheme.primary,
      linearTrackColor: colorScheme.secondaryContainer,
    ),

    // ------------------------------------------
    // LISTAS
    // ------------------------------------------

    listTileTheme: ListTileThemeData(
      iconColor: colorScheme.primary,
      textColor: colorScheme.onSurface,
    ),

    // ------------------------------------------
    // DIVISORES
    // ------------------------------------------

    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant,
      thickness: 1,
    ),

    // ------------------------------------------
    // DIÁLOGOS
    // ------------------------------------------

    dialogTheme: DialogThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
  );

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
        theme: appTheme,
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
