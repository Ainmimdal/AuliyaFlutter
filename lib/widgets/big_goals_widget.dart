import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/child_model.dart';
import '../models/big_goal_model.dart';
import '../providers/child_provider.dart';
import '../services/audio_service.dart';
import '../services/image_picker_service.dart';
import 'star_progress_grid.dart';

/// Preset big goals for easy demo
const List<Map<String, dynamic>> presetBigGoals = [
  {'name': 'New Video Game', 'emoji': '🎮', 'price': 15},
  {'name': 'Trip to Zoo', 'emoji': '🦁', 'price': 20},
  {'name': 'New Toy', 'emoji': '🧸', 'price': 10},
  {'name': 'Movie Night', 'emoji': '🎬', 'price': 8},
  {'name': 'Pizza Party', 'emoji': '🍕', 'price': 12},
];

/// Big Goals Widget - large rewards with animated star progress grid
class BigGoalsWidget extends StatefulWidget {
  final ChildModel child;
  const BigGoalsWidget({super.key, required this.child});

  @override
  State<BigGoalsWidget> createState() => _BigGoalsWidgetState();
}

class _BigGoalsWidgetState extends State<BigGoalsWidget> {
  static const Color colorPrimary = Color(0xFF6A1B9A);
  static const Color colorAccent = Color(0xFFAD1457);
  final AudioService _audio = AudioService();

  void _showAddGoalDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController(text: '10');
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
                  'Add Big Goal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorPrimary),
                ),
                const SizedBox(height: 20),
                
                // Image picker with upload
                GestureDetector(
                  onTap: () async {
                    final downloadUrl = await ImagePickerService.pickCropAndUpload(context, folder: 'goals');
                    if (downloadUrl != null) {
                      setDialogState(() => selectedImagePath = downloadUrl);
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colorPrimary.withOpacity(0.3), width: 2),
                    ),
                    child: selectedImagePath != null && selectedImagePath!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: selectedImagePath!.startsWith('http')
                                ? Image.network(selectedImagePath!, fit: BoxFit.cover, width: 100, height: 100)
                                : (File(selectedImagePath!).existsSync()
                                    ? Image.file(File(selectedImagePath!), fit: BoxFit.cover, width: 100, height: 100)
                                    : _buildPlaceholder()),
                          )
                        : _buildPlaceholder(),
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
                          labelText: 'Goal name',
                          hintText: 'e.g., PlayStation 5',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Quick add popup button
                    PopupMenuButton<Map<String, dynamic>>(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.flash_on, color: colorAccent, size: 24),
                      ),
                      tooltip: 'Quick Add',
                      onSelected: (preset) {
                        nameController.text = preset['name'] as String;
                        priceController.text = (preset['price'] as int).toString();
                      },
                      itemBuilder: (context) => presetBigGoals.map((preset) => 
                        PopupMenuItem<Map<String, dynamic>>(
                          value: preset,
                          child: Row(
                            children: [
                              Text(preset['emoji'] as String, style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 12),
                              Expanded(child: Text(preset['name'] as String)),
                              Text('${preset['price']}⭐', style: const TextStyle(color: Colors.amber)),
                            ],
                          ),
                        ),
                      ).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Stars needed',
                    prefixIcon: const Icon(Icons.star, color: Colors.amber),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
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
                        final name = nameController.text.trim();
                        final price = int.tryParse(priceController.text) ?? 10;
                        if (name.isNotEmpty && price > 0) {
                          _addGoal(name, price, selectedImagePath ?? '');
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

  void _addGoal(String name, int price, String imgPath) async {
    final goal = BigGoal(name: name, price: price, img: imgPath);
    widget.child.bigGoals.add(goal);
    
    // Auto-select if first goal
    if (widget.child.bigGoals.length == 1) {
      widget.child.selectedGoalIndex = 0;
    }
    
    await context.read<ChildProvider>().updateChild(widget.child);
    setState(() {});
  }

  void _selectGoal(int index) async {
    widget.child.selectedGoalIndex = index;
    await context.read<ChildProvider>().updateChild(widget.child);
    setState(() {});
  }

  void _claimGoal(int index) async {
    final goal = widget.child.bigGoals[index];
    if (widget.child.canAffordGoal(goal)) {
      widget.child.claimBigGoal(index); // Deducts stars and marks claimed
      await context.read<ChildProvider>().updateChild(widget.child);
      _audio.playYayComboSound();
      setState(() {});
      
      // Show celebration
      _showClaimCelebration(goal);
    }
  }

  void _showClaimCelebration(BigGoal goal) {
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
                height: 120,
                width: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Show goal image or emoji
                    goal.img.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(File(goal.img), width: 80, height: 80, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Text('🎁', style: TextStyle(fontSize: 50)),
                            ),
                          )
                        : const Text('🏆', style: TextStyle(fontSize: 50)),
                    Positioned.fill(
                      child: Lottie.asset('assets/lottie/congrats.json', repeat: true),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('🎉 Amazing!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colorPrimary)),
              const SizedBox(height: 8),
              Text(
                'You earned: ${goal.name}!',
                style: const TextStyle(fontSize: 18),
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
                child: const Text('Awesome!', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteGoal(int index) async {
    widget.child.bigGoals.removeAt(index);
    if (widget.child.selectedGoalIndex == index) {
      widget.child.selectedGoalIndex = widget.child.bigGoals.isEmpty ? null : 0;
    } else if (widget.child.selectedGoalIndex != null && widget.child.selectedGoalIndex! > index) {
      widget.child.selectedGoalIndex = widget.child.selectedGoalIndex! - 1;
    }
    await context.read<ChildProvider>().updateChild(widget.child);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final selectedGoal = widget.child.selectedGoal;
    
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
                    const Text('Big Goals', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text('${widget.child.star} ⭐ balance', style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _showAddGoalDialog,
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
          
          // Goals horizontal scroll
          if (widget.child.bigGoals.isNotEmpty)
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: widget.child.bigGoals.length,
                itemBuilder: (context, index) {
                  final goal = widget.child.bigGoals[index];
                  final isSelected = widget.child.selectedGoalIndex == index;
                  
                  return GestureDetector(
                    onTap: () => _selectGoal(index),
                    onLongPress: () => _showDeleteDialog(index),
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? colorPrimary : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected ? Border.all(color: Colors.amber, width: 3) : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Goal image or emoji
                          if (goal.img.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(File(goal.img), width: 40, height: 40, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Text(
                                  goal.isClaimed ? '✓' : '🎁',
                                  style: const TextStyle(fontSize: 28),
                                ),
                              ),
                            )
                          else
                            Text(
                              goal.isClaimed ? '✓' : '🎁',
                              style: const TextStyle(fontSize: 28),
                            ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              goal.name,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${widget.child.star.clamp(0, goal.price)}/${goal.price} ⭐',
                            style: TextStyle(
                              color: isSelected ? Colors.amber : Colors.white54,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          
          const SizedBox(height: 16),
          
          // Selected goal progress grid
          Expanded(
            child: selectedGoal == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.emoji_events, size: 60, color: Colors.white.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text(
                          'No goals yet!\nTap "Add" to set a goal.',
                          style: TextStyle(color: Colors.white.withOpacity(0.5)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Goal details card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              // Goal image if available
                              if (selectedGoal.img.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(File(selectedGoal.img), height: 100, fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                                    ),
                                  ),
                                ),
                              
                              // Goal name
                              Text(
                                selectedGoal.name,
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colorPrimary),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                selectedGoal.isClaimed 
                                    ? '✓ Claimed!' 
                                    : '${(selectedGoal.price - widget.child.star).clamp(0, selectedGoal.price)} more stars to go!',
                                style: TextStyle(
                                  fontSize: 14, 
                                  color: selectedGoal.isClaimed ? Colors.green : Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              // Star progress grid - use child.star as progress
                              StarProgressGrid(
                                total: selectedGoal.price,
                                progress: widget.child.star.clamp(0, selectedGoal.price),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Claim button - show if can afford (stars >= price)
                              if (widget.child.canAffordGoal(selectedGoal))
                                ElevatedButton(
                                  onPressed: () => _claimGoal(widget.child.selectedGoalIndex!),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                  ),
                                  child: const Text('🎉 CLAIM REWARD!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                )
                              else if (selectedGoal.isClaimed)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green),
                                      SizedBox(width: 8),
                                      Text('Already claimed!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Goal?'),
        content: Text('Remove "${widget.child.bigGoals[index].name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteGoal(index);
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPlaceholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo, color: Colors.grey, size: 32),
        SizedBox(height: 4),
        Text('Add Photo', style: TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
