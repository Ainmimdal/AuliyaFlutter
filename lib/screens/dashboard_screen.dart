import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/child_model.dart';
import '../providers/child_provider.dart';
import 'child_detail_screen.dart';
import 'child_setup_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Color scheme matching Android app
  static const Color colorPrimary = Color(0xFF6A1B9A); // Purple
  static const Color colorPrimaryDark = Color(0xFF5E35B1);
  static const Color colorAccent = Color(0xFFAD1457); // Pink/Magenta

  @override
  Widget build(BuildContext context) {
    final db = context.watch<DatabaseService>();
    final childProvider = context.read<ChildProvider>();
    final authService = context.watch<AuthService>();

    return StreamBuilder<List<ChildModel>>(
      stream: db.children,
      builder: (context, snapshot) {
        // Update provider when stream data arrives
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            childProvider.setChildren(snapshot.data!);
          });
        }

        return Scaffold(
          backgroundColor: colorPrimaryDark,
          drawer: _buildDrawer(context, authService),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              // Space background
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1A0033), // Dark purple/space
                      Color(0xFF2D1F3D),
                      Color(0xFF3D2952),
                    ],
                  ),
                ),
              ),
              // Stars decoration
              CustomPaint(
                size: Size.infinite,
                painter: StarsPainter(),
              ),
              // Main content
              SafeArea(
                child: Column(
                  children: [
                    // Banner/Logo area
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Image.asset(
                        'assets/images/banner.png',
                        height: 60,
                        errorBuilder: (_, __, ___) => Text(
                          'AULIYA',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: colorAccent.withOpacity(0.5),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Child grid
                    Expanded(
                      child: Consumer<ChildProvider>(
                        builder: (context, childProvider, child) {
                          final children = childProvider.children;
                          if (children.isEmpty) {
                            return const Center(
                              child: Text(
                                "Tiada Rekod",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white54,
                                ),
                              ),
                            );
                          }
                          return GridView.builder(
                            padding: const EdgeInsets.all(20),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: children.length,
                            itemBuilder: (context, index) {
                              return _buildChildCard(context, children[index]);
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
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context, AuthService authService) {
    final user = authService.currentUser;

    return Drawer(
      backgroundColor: colorPrimaryDark,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: colorPrimary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? const Icon(Icons.person, size: 35, color: colorPrimary)
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  user?.displayName ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user?.email ?? '',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title: const Text('Utama', style: TextStyle(color: Colors.white)),
            selected: true,
            selectedTileColor: colorAccent.withOpacity(0.2),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title:
                const Text('Log Keluar', style: TextStyle(color: Colors.white)),
            onTap: () async {
              Navigator.pop(context);
              await authService.signOut();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChildCard(BuildContext context, ChildModel child) {
    return InkWell(
      onTap: () {
        context.read<ChildProvider>().selectChild(child);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChildDetailScreen(child: child),
          ),
        );
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Child avatar with border
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colorPrimary, width: 3),
                ),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: child.img.isNotEmpty
                      ? NetworkImage(child.img)
                      : null,
                  child: child.img.isEmpty
                      ? const Icon(Icons.person,
                          size: 45, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              // Child name
              Text(
                child.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorAccent,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // Age
              Text(
                _calculateAge(child.age),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${child.star}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateAge(String dobString) {
    if (dobString.isEmpty) return '';
    try {
      // Parse date in format MM/dd/yyyy
      final parts = dobString.split('/');
      if (parts.length != 3) return dobString;
      final month = int.parse(parts[0]);
      final day = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      
      final dob = DateTime(year, month, day);
      final now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return '$age Tahun';
    } catch (e) {
      return dobString;
    }
  }

  Widget _buildAddButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showAddChildDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: colorAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 8,
      ),
      child: const Text(
        'Baharu',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showAddChildDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ChildSetupScreen(),
      ),
    );
  }
}

/// Custom painter for star decorations in background
class StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw random stars
    final starPositions = [
      Offset(size.width * 0.1, size.height * 0.15),
      Offset(size.width * 0.8, size.height * 0.1),
      Offset(size.width * 0.3, size.height * 0.25),
      Offset(size.width * 0.9, size.height * 0.3),
      Offset(size.width * 0.15, size.height * 0.45),
      Offset(size.width * 0.7, size.height * 0.55),
      Offset(size.width * 0.5, size.height * 0.08),
      Offset(size.width * 0.95, size.height * 0.5),
    ];

    for (final pos in starPositions) {
      canvas.drawCircle(pos, 1.5, paint);
    }

    // Larger, brighter stars
    paint.color = Colors.white.withOpacity(0.6);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.35), 2, paint);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.2), 2.5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
