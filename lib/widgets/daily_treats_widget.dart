import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/child_model.dart';
import '../models/daily_treat_model.dart';
import '../providers/child_provider.dart';
import '../services/audio_service.dart';
import '../services/image_picker_service.dart';

/// Preset daily treats for easy demo
const List<Map<String, String>> presetDailyTreats = [
  {'name': '30 min Screen Time', 'emoji': '📱'},
  {'name': 'Extra Dessert', 'emoji': '🍦'},
  {'name': 'Stay Up 30 min Late', 'emoji': '🌙'},
  {'name': 'Pick Dinner Menu', 'emoji': '🍕'},
  {'name': 'No Chores Today', 'emoji': '✨'},
];

/// Daily Treats Widget - small rewards claimable after completing the star chart
class DailyTreatsWidget extends StatefulWidget {
  final ChildModel child;
  const DailyTreatsWidget({super.key, required this.child});

  @override
  State<DailyTreatsWidget> createState() => _DailyTreatsWidgetState();
}

class _DailyTreatsWidgetState extends State<DailyTreatsWidget> {
  static const Color colorPrimary = Color(0xFF6A1B9A);
  static const Color colorAccent = Color(0xFFAD1457);
  final AudioService _audio = AudioService();

  void _showAddTreatDialog() {
    final nameController = TextEditingController();
    String? selectedImagePath;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add Daily Treat',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorPrimary),
                ),
                const SizedBox(height: 20),
                
                // Image picker using service
                GestureDetector(
                  onTap: () async {
                    final path = await ImagePickerService.pickAndCropImage(context);
                    if (path != null) {
                      setDialogState(() => selectedImagePath = path);
                    }
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorPrimary.withOpacity(0.3)),
                    ),
                    child: selectedImagePath != null && File(selectedImagePath!).existsSync()
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Image.file(File(selectedImagePath!), fit: BoxFit.cover, width: 80, height: 80),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, color: Colors.grey, size: 28),
                              SizedBox(height: 4),
                              Text('Add Photo', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Name field with quick add button
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Treat name',
                          hintText: 'e.g., 2 hours gaming',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Quick add popup button
                    PopupMenuButton<String>(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.flash_on, color: colorAccent, size: 24),
                      ),
                      tooltip: 'Quick Add',
                      onSelected: (value) => nameController.text = value,
                      itemBuilder: (context) => presetDailyTreats.map((preset) => 
                        PopupMenuItem<String>(
                          value: preset['name']!,
                          child: Row(
                            children: [
                              Text(preset['emoji']!, style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 12),
                              Text(preset['name']!),
                            ],
                          ),
                        ),
                      ).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (nameController.text.trim().isNotEmpty) {
                          _addTreat(nameController.text.trim(), selectedImagePath ?? '');
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Add', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addTreat(String name, String imgPath) async {
    final treat = DailyTreat(name: name, img: imgPath);
    widget.child.dailyTreats.add(treat);
    await context.read<ChildProvider>().updateChild(widget.child);
    setState(() {});
  }

  void _claimTreat(int index) async {
    // Check if treats available
    if (widget.child.treatsAvailable <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete the Star Chart first to earn a treat!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    // Deduct treat and show celebration
    widget.child.claimDailyTreat();
    await context.read<ChildProvider>().updateChild(widget.child);
    _audio.playYaySound();
    
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Text('🎁', style: TextStyle(fontSize: 50)),
                    Positioned.fill(
                      child: Lottie.asset('assets/lottie/congrats.json', repeat: false),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('🎉 Enjoy!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                widget.child.dailyTreats[index].name,
                style: const TextStyle(fontSize: 18, color: colorPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
    setState(() {});
  }

  void _deleteTreat(int index) async {
    widget.child.dailyTreats.removeAt(index);
    await context.read<ChildProvider>().updateChild(widget.child);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A0033), Color(0xFF2D1F3D)],
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daily Treats',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    // Treats available counter
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.child.treatsAvailable > 0 ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${widget.child.treatsAvailable} treats available',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _showAddTreatDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
          ),
          // Info text
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Complete the Star Chart to earn 1 treat claim!',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),
          // Treats list
          Expanded(
            child: widget.child.dailyTreats.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.card_giftcard, size: 60, color: Colors.white.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text(
                          'No treats yet!\nTap "Add" to create one.',
                          style: TextStyle(color: Colors.white.withOpacity(0.5)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: widget.child.dailyTreats.length,
                    itemBuilder: (context, index) {
                      final treat = widget.child.dailyTreats[index];
                      return Dismissible(
                        key: Key('treat_$index'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => _deleteTreat(index),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: treat.img.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(File(treat.img), width: 50, height: 50, fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _buildDefaultIcon(),
                                    ),
                                  )
                                : _buildDefaultIcon(),
                            title: Text(treat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            trailing: ElevatedButton(
                              onPressed: widget.child.treatsAvailable > 0 ? () => _claimTreat(index) : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.child.treatsAvailable > 0 ? Colors.green : Colors.grey,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Text('Claim', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultIcon() {
    return const CircleAvatar(
      backgroundColor: Color(0xFFFFF3E0),
      child: Text('🎁', style: TextStyle(fontSize: 24)),
    );
  }
}
