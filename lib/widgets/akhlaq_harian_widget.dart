import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../models/child_model.dart';
import '../providers/child_provider.dart';
import '../services/audio_service.dart';

/// Akhlaq Harian Widget - matches Android's AkhlaqHarian fragment
/// Layout: ScrollView with artboard.png background + Lottie overlay
/// Buttons fixed at bottom-right outside scroll
class AkhlaqHarianWidget extends StatefulWidget {
  final ChildModel child;

  const AkhlaqHarianWidget({super.key, required this.child});

  @override
  State<AkhlaqHarianWidget> createState() => _AkhlaqHarianWidgetState();
}

class _AkhlaqHarianWidgetState extends State<AkhlaqHarianWidget>
    with TickerProviderStateMixin {
  static const Color colorGood = Color(0xFF4CAF50);
  static const Color colorBad = Color(0xFFE53935);
  static const Color colorPrimary = Color(0xFF6A1B9A);

  late AnimationController _rocketController;
  final AudioService _audio = AudioService();
  final ScrollController _scrollController = ScrollController();
  
  static const int totalFrames = 1560;
  
  static const Map<int, int> levelFrames = {
    0: 0,
    1: 180,
    2: 342,
    3: 527,
    4: 696,
    5: 890,
    6: 1055,
    7: 1231,
    8: 1401,
  };

  double _goodButtonScale = 1.0;
  double _badButtonScale = 1.0;
  bool _isAnimatingToStar = false;

  @override
  void initState() {
    super.initState();
    _rocketController = AnimationController(vsync: this);
    _rocketController.addStatusListener((status) {
      if (status == AnimationStatus.completed && _isAnimatingToStar) {
        _onStarAnimationComplete();
      }
    });
  }

  @override
  void dispose() {
    _rocketController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onLottieLoaded(LottieComposition composition) {
    _rocketController.duration = composition.duration;
    _setRocketPosition(widget.child.level);
    // Scroll to show current level position after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToLevel(widget.child.level);
    });
  }

  void _setRocketPosition(int level) {
    if (level >= 9) {
      _rocketController.value = 0;
    } else if (levelFrames.containsKey(level)) {
      final frame = levelFrames[level]!;
      _rocketController.value = frame / totalFrames;
    }
  }

  // Scroll to show the rocket at current level
  // Level 0 = bottom, Level 8 = top
  void _scrollToLevel(int level) {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    // Higher levels = scroll towards top (lower offset)
    // At level 0, scroll to max (bottom). At level 8, scroll to 0 (top).
    final ratio = 1.0 - (level / 8.0);
    final target = maxScroll * ratio;
    _scrollController.animateTo(
      target.clamp(0.0, maxScroll),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void _animateRocketUp(int fromLevel, int toLevel) {
    final fromFrame = levelFrames[fromLevel] ?? 0;
    final toFrame = levelFrames[toLevel] ?? totalFrames;
    _rocketController.value = fromFrame / totalFrames;
    _rocketController.animateTo(
      toFrame / totalFrames,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOut,
    );
    _scrollToLevel(toLevel);
  }

  void _animateRocketDown(int fromLevel, int toLevel) {
    final fromFrame = levelFrames[fromLevel] ?? 0;
    final toFrame = levelFrames[toLevel] ?? 0;
    _rocketController.value = fromFrame / totalFrames;
    _rocketController.animateTo(
      toFrame / totalFrames,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOut,
    );
    _scrollToLevel(toLevel);
  }

  void _animateToStar() {
    _isAnimatingToStar = true;
    _rocketController.animateTo(1.0, duration: const Duration(milliseconds: 1500), curve: Curves.easeInOut);
    // Scroll to top
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0, duration: const Duration(milliseconds: 1500), curve: Curves.easeInOut);
    }
  }

  void _onStarAnimationComplete() async {
    _isAnimatingToStar = false;
    _audio.playYayComboSound();
    _showStarEarnedDialog();
    await Future.delayed(const Duration(milliseconds: 100));
    _rocketController.value = 0;
    // Scroll back to bottom
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _onGoodPressed() async {
    if (_isAnimatingToStar) return;
    
    setState(() => _goodButtonScale = 0.9);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _goodButtonScale = 1.0);

    _audio.playGoodSound();

    final provider = context.read<ChildProvider>();
    final oldLevel = widget.child.level;
    
    // Check if we'll earn a star (level will become 9)
    if (widget.child.level >= 8) {
      // Animate to top and earn star
      _animateToStar();
      widget.child.increaseScore(); // This handles star++ and level reset
      await provider.updateChild(widget.child);
    } else {
      widget.child.level++;
      _animateRocketUp(oldLevel, widget.child.level);
      await provider.updateChild(widget.child);
    }
    setState(() {});
  }

  Future<void> _onBadPressed() async {
    if (_isAnimatingToStar) return;
    if (widget.child.level <= 0) return;
    
    setState(() => _badButtonScale = 0.9);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _badButtonScale = 1.0);

    _audio.playBadSound();

    final provider = context.read<ChildProvider>();
    final oldLevel = widget.child.level;
    
    widget.child.level--;
    _animateRocketDown(oldLevel, widget.child.level);
    await provider.updateChild(widget.child);
    setState(() {});
  }

  void _showStarEarnedDialog() {
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
              // Star with confetti on top
              SizedBox(
                height: 120,
                width: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 70),
                    Positioned.fill(
                      child: Lottie.asset('assets/lottie/congrats.json', repeat: true),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Hooray!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colorPrimary)),
              const SizedBox(height: 8),
              const Text('Anda dapat satu bintang!', style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Ok', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // SCROLLABLE: Background image + Lottie animation stacked
        SingleChildScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          child: Stack(
            children: [
              // Background: artboard.png (or fallback gradient)
              Image.asset(
                'assets/images/artboard.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
                errorBuilder: (_, __, ___) {
                  // Fallback: create tall gradient container
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 3, // Tall for scrolling
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF0B0B2B), // Dark space blue
                          Color(0xFF1A1A4A),
                          Color(0xFF2D2D6A),
                          Color(0xFF3D3D8A),
                        ],
                      ),
                    ),
                  );
                },
              ),
              // Lottie: rocket animation overlaid on background
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Lottie.asset(
                  'assets/lottie/rocketnewestee.json',
                  controller: _rocketController,
                  onLoaded: _onLottieLoaded,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                ),
              ),
            ],
          ),
        ),
        
        // FIXED: Level indicator (top-left)
        Positioned(
          top: 16,
          left: 16,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Level ${widget.child.level + 1}/10   ⭐${widget.child.star}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
        
        // FIXED: Good/Bad buttons (bottom-right, outside scroll)
        Positioned(
          right: 8,
          bottom: 8,
          child: Column(
            children: [
              // Good button
              GestureDetector(
                onTap: _onGoodPressed,
                child: AnimatedScale(
                  scale: _goodButtonScale,
                  duration: const Duration(milliseconds: 100),
                  child: Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      color: colorPrimary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
                    ),
                    child: const Icon(Icons.thumb_up, color: Colors.white, size: 28),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Bad button
              GestureDetector(
                onTap: _onBadPressed,
                child: AnimatedScale(
                  scale: _badButtonScale,
                  duration: const Duration(milliseconds: 100),
                  child: Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      color: colorBad,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
                    ),
                    child: const Icon(Icons.thumb_down, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
