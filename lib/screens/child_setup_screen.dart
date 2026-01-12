import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/child_model.dart';
import '../providers/child_provider.dart';
import '../services/image_picker_service.dart';

/// Child Setup Screen - for creating/editing children
class ChildSetupScreen extends StatefulWidget {
  final ChildModel? existingChild;

  const ChildSetupScreen({super.key, this.existingChild});

  @override
  State<ChildSetupScreen> createState() => _ChildSetupScreenState();
}

class _ChildSetupScreenState extends State<ChildSetupScreen> {
  static const Color colorPrimary = Color(0xFF6A1B9A);
  static const Color colorAccent = Color(0xFFAD1457);

  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  String? _localImagePath; // Local file path for new/changed image
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingChild != null) {
      _nameController.text = widget.existingChild!.name;
      _dobController.text = widget.existingChild!.age;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final path = await ImagePickerService.pickAndCropImage(context);
    if (path != null) {
      setState(() {
        _localImagePath = path;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: colorPrimary,
              onPrimary: Colors.white,
              secondary: colorAccent,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text =
            '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  Future<void> _saveChild() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final provider = context.read<ChildProvider>();
      
      // Use local path for now - later can upload to Firebase Storage
      final imagePath = _localImagePath ?? widget.existingChild?.img ?? '';

      if (widget.existingChild != null) {
        // Edit mode
        final child = widget.existingChild!;
        child.name = _nameController.text.trim();
        child.age = _dobController.text;
        child.img = imagePath;
        await provider.updateChild(child);
      } else {
        // Create mode
        final newChild = ChildModel(
          name: _nameController.text.trim(),
          age: _dobController.text,
          img: imagePath,
          level: 0,
          star: 0,
        );
        await provider.addChild(newChild);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingChild != null;

    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    isEditing ? 'Edit Child' : 'New Child',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Profile image picker
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: colorPrimary, width: 3),
                            color: Colors.grey[200],
                          ),
                          child: ClipOval(
                            child: _buildProfileImage(),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: colorAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to add photo',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),

                  // Name field
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: const TextStyle(color: colorPrimary),
                      prefixIcon: const Icon(Icons.person, color: colorPrimary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: colorPrimary, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // DOB field
                  GestureDetector(
                    onTap: _selectDate,
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _dobController,
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          labelStyle: const TextStyle(color: colorPrimary),
                          prefixIcon: const Icon(Icons.cake, color: colorPrimary),
                          suffixIcon: const Icon(Icons.calendar_today, color: colorPrimary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: colorPrimary, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colorPrimary,
                            side: const BorderSide(color: colorPrimary),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveChild,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorPrimary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    // Priority: new local image > existing local path > network URL > placeholder
    if (_localImagePath != null && File(_localImagePath!).existsSync()) {
      return Image.file(
        File(_localImagePath!),
        width: 104,
        height: 104,
        fit: BoxFit.cover,
      );
    }
    
    if (widget.existingChild != null && widget.existingChild!.img.isNotEmpty) {
      final img = widget.existingChild!.img;
      // Check if it's a local path or network URL
      if (File(img).existsSync()) {
        return Image.file(
          File(img),
          width: 104,
          height: 104,
          fit: BoxFit.cover,
        );
      } else if (img.startsWith('http')) {
        return Image.network(
          img,
          width: 104,
          height: 104,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(),
        );
      }
    }
    
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 104,
      height: 104,
      color: Colors.grey[200],
      child: const Icon(Icons.person, size: 50, color: Colors.grey),
    );
  }
}
