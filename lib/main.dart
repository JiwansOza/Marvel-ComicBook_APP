import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:marvel_comics_app/screens/home_screen.dart';
import 'package:marvel_comics_app/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:marvel_comics_app/providers/comics_provider.dart';
import 'package:marvel_comics_app/providers/favorites_provider.dart';
import 'package:marvel_comics_app/services/api_service.dart';

Future<void> main() async {
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // Get API keys from environment variables
  final publicKey = dotenv.env['MARVEL_PUBLIC_KEY'] ?? '';
  final privateKey = dotenv.env['MARVEL_PRIVATE_KEY'] ?? '';
  
  // Check if API keys are available
  if (publicKey.isEmpty || privateKey.isEmpty) {
    print('WARNING: Marvel API keys not found. Using mock data.');
  }
  
  runApp(MyApp(
    publicKey: publicKey,
    privateKey: privateKey,
  ));
}

class MyApp extends StatelessWidget {
  final String publicKey;
  final String privateKey;

  const MyApp({
    super.key,
    required this.publicKey,
    required this.privateKey,
  });

  @override
  Widget build(BuildContext context) {
    // Create API service with Marvel credentials
    final apiService = ApiService(
      publicKey: publicKey,
      privateKey: privateKey,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ComicsProvider(apiService: apiService),
        ),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MaterialApp(
        title: 'Marvel Comics',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}

