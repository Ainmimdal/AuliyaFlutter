import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/child_model.dart';
import '../providers/child_provider.dart';
import '../widgets/akhlaq_harian_widget.dart';
import '../widgets/ganjaran_widget.dart';
import 'child_setup_screen.dart';

/// Child Detail Screen - matches Android's ChilddetailActivity
class ChildDetailScreen extends StatefulWidget {
  final ChildModel child;
  const ChildDetailScreen({super.key, required this.child});

  @override
  State<ChildDetailScreen> createState() => _ChildDetailScreenState();
}

class _ChildDetailScreenState extends State<ChildDetailScreen>
    with SingleTickerProviderStateMixin {
  static const Color colorPrimary = Color(0xFF6A1B9A);
  static const Color colorAccent = Color(0xFFAD1457);

  late TabController _tabController;
  late ChildModel _child;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _child = widget.child;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return '$age Tahun';
    } catch (e) {
      return dobString;
    }
  }

  void _editChild() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChildSetupScreen(existingChild: _child),
      ),
    );
  }

  void _deleteChild() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Padam?'),
        content: Text('Adakah anda pasti mahu padam ${_child.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<ChildProvider>().deleteChild(_child);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to provider for real-time updates
    return Consumer<ChildProvider>(
      builder: (context, provider, _) {
        // Update local child if it's in the provider
        final updated =
            provider.children.where((c) => c.id == _child.id).firstOrNull;
        if (updated != null) {
          _child = updated;
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // Header with child info
              _buildHeader(context),
              // Tab bar
              Container(
                color: colorPrimary,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 4,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  tabs: const [
                    Tab(text: 'Akhlaq Harian'),
                    Tab(text: 'Ganjaran'),
                    Tab(text: 'Bonus'),
                  ],
                ),
              ),
              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    AkhlaqHarianWidget(child: _child),
                    GanjaranWidget(child: _child, isBonus: false),
                    GanjaranWidget(child: _child, isBonus: true),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: colorPrimary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              // Back button
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              // Child image
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      _child.img.isNotEmpty ? NetworkImage(_child.img) : null,
                  child: _child.img.isEmpty
                      ? const Icon(Icons.person, size: 32, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              // Name and age
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _child.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          _calculateAge(_child.age),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Star count
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${_child.star}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'edit') {
                    _editChild();
                  } else if (value == 'delete') {
                    _deleteChild();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Padam', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
