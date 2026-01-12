import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
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
    // We need a userId to instantiate DatabaseService. 
    // For now, we'll wait for Auth State in a wrapper or assume anonymous.
    // A better approach is using ProxyProvider or initializing DB service after Auth.
    // For simplicity in this migration, we'll setup Providers at root, 
    // but ChildProvider needs a DatabaseService which needs a UID.
    
    // We will use a StreamProvider for User?, then a valid DatabaseService.
    
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges, 
          initialData: null,
        ),
        ChangeNotifierProvider(create: (_) => RewardProvider()..loadRewards()),
        // ChildProvider depends on DatabaseService, which depends on Auth.
        // We can handle this logic in a wrapper widget or use ProxyProvider.
        // For now, we'll initialize ChildProvider with a placeholder and update it 
        // or let the UI handle the connection.
        // Let's use ProxyProvider for DatabaseService.
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Inter', // Assuming Google Fonts 'Inter' or similar
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
