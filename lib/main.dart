import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/detail_screen.dart';
import 'models/product.dart';
import 'services/api_service.dart';
import 'services/cart_service.dart';
import 'services/session_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await CartService.instance.init();
  final username = await SessionService.getLoggedInUsername();

  runApp(MyApp(initialUsername: username));
}

class MyApp extends StatelessWidget {
  final String? initialUsername;

  const MyApp({super.key, required this.initialUsername});

  @override
  Widget build(BuildContext context) {
    const primaryOrange = Color(0xFFF57C00);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryOrange,
      brightness: Brightness.light,
    ).copyWith(
      primary: primaryOrange,
      secondary: primaryOrange,
      tertiary: Colors.orangeAccent,
    );

    return MaterialApp(
      title: 'Keriprikoll',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFFFF7F0),
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0xFFFFF1E6),
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: Colors.orange.shade300,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.primary,
          ),
        ),
        iconTheme: IconThemeData(color: colorScheme.primary),
        useMaterial3: true,
      ),
      home: initialUsername == null
          ? const LoginScreen()
          : MainScreen(username: initialUsername!),
      onGenerateRoute: (settings) {
        final name = settings.name ?? '';
        final uri = Uri.parse(name);

        if (uri.path == '/detail') {
          final idStr = uri.queryParameters['id'];
          final username = settings.arguments as String?;

          return MaterialPageRoute(
            builder: (context) => _DetailLoaderPage(
              idStr: idStr,
              username: username,
            ),
          );
        }

        return null;
      },
    );
  }
}

class _DetailLoaderPage extends StatelessWidget {
  final String? idStr;
  final String? username;

  const _DetailLoaderPage({this.idStr, this.username, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (idStr == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Game')),
        body: const Center(child: Text('ID game tidak diberikan.')),
      );
    }

    final id = int.tryParse(idStr!);
    if (id == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Game')),
        body: const Center(child: Text('ID game tidak valid.')),
      );
    }

    return FutureBuilder<Product>(
      future: ApiService.fetchProductById(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detail Game')),
            body: Center(child: Text('Gagal memuat data: ${snapshot.error}')),
          );
        }

        final product = snapshot.data;
        if (product == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detail Game')),
            body: const Center(child: Text('Game tidak ditemukan.')),
          );
        }

        return DetailScreen(username: username ?? '', product: product);
      },
    );
  }
}
