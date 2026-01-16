import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/child_model.dart';
import '../providers/child_provider.dart';
import '../widgets/akhlaq_harian_widget.dart';
import '../widgets/daily_treats_widget.dart';
import '../widgets/big_goals_widget.dart';
import 'child_setup_screen.dart';

/// Child Detail Screen - displays child's star chart, treats, and goals
class ChildDetailScreen extends StatefulWidget {
  final ChildModel child;
  const ChildDetailScreen({super.key, required this.child});

  @override
  State<ChildDetailScreen> createState() => _ChildDetailScreenState();
}

class _ChildDetailScreenState extends State<ChildDetailScreen>
    with SingleTickerProviderStateMixin {
  static const Color colorPrimary = Color(0xFF6A1B9A);

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
      if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return '$age years old';
    } catch (e) {
      return dobString;
    }
  }

  void _editChild() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChildSetupScreen(existingChild: _child)),
    );
  }

  void _deleteChild() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete?'),
        content: Text('Are you sure you want to delete ${_child.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
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
    return Consumer<ChildProvider>(
      builder: (context, provider, _) {
        final updated = provider.children.where((c) => c.id == _child.id).firstOrNull;
        if (updated != null) _child = updated;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              _buildHeader(context),
              // Tab bar with new labels
              Container(
                color: colorPrimary,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 4,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  tabs: const [
                    Tab(text: 'Star Chart'),
                    Tab(text: 'Daily Treats'),
                    Tab(text: 'Big Goals'),
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
                    DailyTreatsWidget(child: _child),
                    BigGoalsWidget(child: _child),
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
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _getChildImage(_child.img),
                  child: _child.img.isEmpty
                      ? const Icon(Icons.person, size: 32, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _child.name,
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(_calculateAge(_child.age), style: const TextStyle(color: Colors.white70, fontSize: 14)),
                        const SizedBox(width: 16),
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text('${_child.star}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'edit') _editChild();
                  else if (value == 'delete') _deleteChild();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 20), SizedBox(width: 8), Text('Edit')])),
                  const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 20, color: Colors.red), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
}
