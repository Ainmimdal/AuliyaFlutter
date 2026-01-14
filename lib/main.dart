import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'providers/child_provider.dart';
import 'providers/reward_provider.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase initialization failed: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges, 
          initialData: null,
        ),
        ChangeNotifierProvider(create: (_) => RewardProvider()..loadRewards()),
        ProxyProvider<User?, DatabaseService>(
          update: (_, user, __) => DatabaseService(uid: user?.uid ?? ''),
        ),
        ChangeNotifierProxyProvider<DatabaseService, ChildProvider>(
          create: (context) => ChildProvider(context.read<DatabaseService>()),
          update: (context, db, previous) => ChildProvider(db),
        ),
      ],
      child: MaterialApp(
        title: 'Auliya',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6A1B9A),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          // Use Nunito font family
          textTheme: GoogleFonts.nunitoTextTheme(
            Theme.of(context).textTheme,
          ),
          fontFamily: GoogleFonts.nunito().fontFamily,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
