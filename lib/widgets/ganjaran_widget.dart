import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../models/child_model.dart';
import '../models/harian_model.dart';
import '../models/bonus_model.dart';
import '../providers/child_provider.dart';
import '../services/audio_service.dart';

/// Ganjaran Widget - matches Android's GanjaranKotlin fragment
/// Shows Harian or Bonus list with add/claim functionality
class GanjaranWidget extends StatefulWidget {
  final ChildModel child;
  final bool isBonus;

  const GanjaranWidget({
    super.key,
    required this.child,
    required this.isBonus,
  });

  @override
  State<GanjaranWidget> createState() => _GanjaranWidgetState();
}

class _GanjaranWidgetState extends State<GanjaranWidget> {
  static const Color colorPrimary = Color(0xFF6A1B9A);
  static const Color colorAccent = Color(0xFFAD1457);
  final AudioService _audio = AudioService();

  void _showAddDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.isBonus ? 'Tambah Bonus' : 'Tambah Harian',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorPrimary,
                ),
              ),
              const SizedBox(height: 24),
              // Name field
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Price field
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: widget.isBonus ? 'Harga (Bintang)' : 'Nilai',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _addItem(
                      nameController.text,
                      int.tryParse(priceController.text) ?? 1,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Tambah',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addItem(String name, int price) async {
    if (name.trim().isEmpty) return;
    Navigator.pop(context);

    final provider = context.read<ChildProvider>();
    if (widget.isBonus) {
      await provider.addBonus(
        widget.child,
        BonusModel(name: name.trim(), price: price),
      );
    } else {
      await provider.addHarian(
        widget.child,
        HarianModel(name: name.trim(), price: price),
      );
    }
  }

  void _showClaimDialog(dynamic item, int index) {
    final String name = widget.isBonus
        ? (item as BonusModel).name
        : (item as HarianModel).name;
    final int price =
        widget.isBonus ? (item as BonusModel).price : (item as HarianModel).price;
    final int available =
        widget.isBonus ? widget.child.star : widget.child.hariankey;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.card_giftcard, size: 50, color: colorPrimary),
              const SizedBox(height: 16),
              const Text(
                'Claim Bonus?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                'Harga: $price ${widget.isBonus ? "Bintang" : "Hariankey"}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              Text(
                'Ada: $available',
                style: TextStyle(
                  color: available >= price ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tidak'),
                  ),
                  ElevatedButton(
                    onPressed: available >= price
                        ? () => _claimItem(item, index)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary,
                    ),
                    child:
                        const Text('Ya', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _claimItem(dynamic item, int index) async {
    Navigator.pop(context);

    final provider = context.read<ChildProvider>();
    bool success = false;

    if (widget.isBonus) {
      success = await provider.claimBonus(widget.child, item as BonusModel);
    } else {
      success = await provider.claimHarian(widget.child, item as HarianModel);
    }

    if (success) {
      _audio.playYaySound();
      _showSuccessDialog(
          widget.isBonus ? (item as BonusModel).name : (item as HarianModel).name);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Belum layak!')),
      );
    }
  }

  void _showSuccessDialog(String itemName) {
    showDialog(
      context: context,
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
                child: Lottie.asset(
                  'assets/lottie/congrats.json',
                  repeat: true,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Yay!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Anda dapat $itemName!',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Ok', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteItem(int index) async {
    final provider = context.read<ChildProvider>();
    if (widget.isBonus) {
      await provider.removeBonus(widget.child, index);
    } else {
      await provider.removeHarian(widget.child, index);
    }
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.isBonus ? 'Bonus' : 'Harian',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colorPrimary,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _showAddDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Tambah',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Balance indicator
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.isBonus ? Icons.star : Icons.check_circle,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.isBonus
                            ? 'Bintang: ${widget.child.star}'
                            : 'Hariankey: ${widget.child.hariankey}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // List
                _buildList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    final items =
        widget.isBonus ? widget.child.bonus : widget.child.harian;

    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Tiada item. Tekan "Tambah" untuk menambah.',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Dismissible(
          key: Key('${widget.isBonus ? 'bonus' : 'harian'}_$index'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => _deleteItem(index),
          child: Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: colorPrimary.withOpacity(0.1),
                child: Icon(
                  widget.isBonus ? Icons.card_giftcard : Icons.check_circle,
                  color: colorPrimary,
                ),
              ),
              title: Text(
                widget.isBonus
                    ? (item as BonusModel).name
                    : (item as HarianModel).name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                widget.isBonus
                    ? '${(item as BonusModel).price} Bintang'
                    : '${(item as HarianModel).price} Hariankey',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showClaimDialog(item, index),
            ),
          ),
        );
      },
    );
  }
}
