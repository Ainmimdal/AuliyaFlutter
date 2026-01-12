import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:math' as math;
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/child_model.dart';
import '../providers/child_provider.dart';
import 'child_detail_screen.dart';
import 'child_setup_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  static const Color colorPrimary = Color(0xFF6A1B9A);
  static const Color colorPrimaryDark = Color(0xFF4A148C);
  static const Color colorAccent = Color(0xFFE91E63);
  static const Color colorGold = Color(0xFFFFD700);
  
  late AnimationController _floatingController;
  
  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = context.watch<DatabaseService>();
    final childProvider = context.read<ChildProvider>();
    final authService = context.watch<AuthService>();

    return StreamBuilder<List<ChildModel>>(
      stream: db.children,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            childProvider.setChildren(snapshot.data!);
          });
        }

        return Scaffold(
          extendBodyBehindAppBar: true,
          drawer: _buildDrawer(context, authService),
          body: Stack(
            children: [
              // Animated gradient background
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1A0A2E),
                      Color(0xFF2D1F4A),
                      Color(0xFF3D2952),
                      Color(0xFF1A0A2E),
                    ],
                    stops: [0.0, 0.3, 0.6, 1.0],
                  ),
                ),
              ),
              // Animated stars and decorations
              CustomPaint(
                size: Size.infinite,
                painter: EnhancedStarsPainter(),
              ),
              // Glowing orbs
              _buildGlowingOrbs(),
              // Main content
              SafeArea(
                child: Column(
                  children: [
                    // Custom app bar
                    _buildAppBar(context),
                    // Welcome section
                    _buildWelcomeSection(),
                    // Child grid
                    Expanded(
                      child: Consumer<ChildProvider>(
                        builder: (context, childProvider, child) {
                          final children = childProvider.children;
                          if (children.isEmpty) {
                            return _buildEmptyState();
                          }
                          return GridView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: children.length,
                            itemBuilder: (context, index) {
                              return _buildChildCard(context, children[index], index);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: _buildAddButton(context),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  Widget _buildGlowingOrbs() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: 100 + math.sin(_floatingController.value * math.pi) * 20,
              right: 30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorAccent.withOpacity(0.4),
                      colorAccent.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 200 + math.cos(_floatingController.value * math.pi) * 15,
              left: 20,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorPrimary.withOpacity(0.5),
                      colorPrimary.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Menu button with glassmorphism
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          const Spacer(),
          // App logo/title
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [colorGold, Colors.white, colorGold],
            ).createShader(bounds),
            child: const Text(
              'AULIYA',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48), // Balance for menu button
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Children',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: colorAccent.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Track their progress & rewards',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.child_care_rounded,
              size: 60,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No children yet',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first child to get started!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildCard(BuildContext context, ChildModel child, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + index * 100),
      curve: Curves.easeOutBack,
      builder: (context, value, widget) {
        return Transform.scale(
          scale: value,
          child: widget,
        );
      },
      child: GestureDetector(
        onTap: () {
          context.read<ChildProvider>().selectChild(child);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ChildDetailScreen(child: child)),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: colorPrimary.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: -5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glowing avatar
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [colorAccent, colorPrimary],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorAccent.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.grey[900],
                    backgroundImage: _getChildImage(child.img),
                    child: child.img.isEmpty
                        ? const Icon(Icons.person, size: 40, color: Colors.white70)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                // Name
                Text(
                  child.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Age
                Text(
                  _calculateAge(child.age),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 12),
                // Stars badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorGold.withOpacity(0.3), colorGold.withOpacity(0.1)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colorGold.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, color: colorGold, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${child.star}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorGold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, AuthService authService) {
    final user = authService.currentUser;

    return Drawer(
      backgroundColor: const Color(0xFF1A0A2E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colorPrimary, colorPrimaryDark],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                    child: user?.photoURL == null
                        ? const Icon(Icons.person, size: 32, color: colorPrimary)
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user?.displayName ?? 'Parent',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  user?.email ?? 'Welcome!',
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.home_rounded, 'Home', true, () => Navigator.pop(context)),
          _buildDrawerItem(Icons.settings_rounded, 'Settings', false, () {}),
          const Divider(color: Colors.white24),
          _buildDrawerItem(Icons.logout_rounded, 'Sign Out', false, () async {
            Navigator.pop(context);
            await authService.signOut();
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, bool selected, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: selected ? colorAccent : Colors.white70),
      title: Text(title, style: TextStyle(color: selected ? colorAccent : Colors.white)),
      selected: selected,
      selectedTileColor: colorAccent.withOpacity(0.1),
      onTap: onTap,
    );
  }

  String _calculateAge(String dobString) {
    if (dobString.isEmpty) return '';
    try {
      final parts = dobString.split('/');
      if (parts.length != 3) return dobString;
      final month = int.parse(parts[0]);
      final day = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final dob = DateTime(year, month, day);
      final now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return '$age years old';
    } catch (e) {
      return dobString;
    }
  }
  
  /// Get image provider from local path or network URL
  ImageProvider? _getChildImage(String imagePath) {
    if (imagePath.isEmpty) return null;
    
    // Check if it's a local file
    final file = File(imagePath);
    if (file.existsSync()) {
      return FileImage(file);
    }
    
    // Check if it's a network URL
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    }
    
    return null;
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(colors: [colorAccent, colorPrimary]),
        boxShadow: [
          BoxShadow(
            color: colorAccent.withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChildSetupScreen()),
        ),
        icon: const Icon(Icons.add_rounded, size: 24),
        label: const Text('Add Child', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}

/// Enhanced stars painter with twinkling effect
class EnhancedStarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42); // Fixed seed for consistent star positions
    
    // Small dim stars
    final smallPaint = Paint()..color = Colors.white.withOpacity(0.3);
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), 0.8 + random.nextDouble() * 0.5, smallPaint);
    }
    
    // Medium stars with glow
    final mediumPaint = Paint()..color = Colors.white.withOpacity(0.6);
    for (int i = 0; i < 15; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height * 0.7;
      canvas.drawCircle(Offset(x, y), 1.5, mediumPaint);
    }
    
    // Large bright stars
    final brightPaint = Paint()..color = Colors.white.withOpacity(0.9);
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.2), 2.5, brightPaint);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.15), 3, brightPaint);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.08), 2, brightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
