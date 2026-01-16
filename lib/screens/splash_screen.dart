import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'dashboard_screen.dart'; 
// We will implement navigation logic here later.

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/spacebg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Lottie.asset(
            'assets/lottie/splashscreensmol.json',
            controller: _controller,
            onLoaded: (composition) {
              // Slow down splash animation slightly (1.2x duration)
              _controller
                ..duration = composition.duration * 1.2
                ..forward().whenComplete(() async {
                  // Sign in with Google
                  final auth = context.read<AuthService>();
                  if (auth.currentUser == null) {
                    print("Signing in with Google...");
                    final user = await auth.signInWithGoogle();
                    if (user == null) {
                      print("Google Sign-In failed, using anonymous...");
                      await auth.signInAnonymously();
                    }
                  }
                  
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const DashboardScreen()),
                    );
                  }
                });
            },
          ),
        ),
      ),
    );
  }
}
