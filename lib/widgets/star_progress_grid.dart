import 'package:flutter/material.dart';

/// StarProgressGrid - animated grid showing progress toward a big goal
/// Uses smart scaling to keep grid manageable for large star counts
class StarProgressGrid extends StatefulWidget {
  final int total;     // Total stars needed
  final int progress;  // Stars earned so far
  
  const StarProgressGrid({
    super.key,
    required this.total,
    required this.progress,
  });

  @override
  State<StarProgressGrid> createState() => _StarProgressGridState();
}

class _StarProgressGridState extends State<StarProgressGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    // Start animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animController.forward();
    });
  }

  @override
  void didUpdateWidget(StarProgressGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animController.reset();
      _animController.forward();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  /// Calculate scale factor and grid dimensions
  /// Returns: (starsPerCell, numCells, columns)
  (int, int, int) _calculateGrid() {
    int starsPerCell;
    if (widget.total <= 20) {
      starsPerCell = 1;
    } else if (widget.total <= 50) {
      starsPerCell = 5;
    } else if (widget.total <= 100) {
      starsPerCell = 10;
    } else {
      starsPerCell = 20;
    }
    
    int numCells = (widget.total / starsPerCell).ceil();
    int columns = numCells <= 10 ? 5 : (numCells <= 20 ? 5 : 10);
    
    return (starsPerCell, numCells, columns);
  }

  @override
  Widget build(BuildContext context) {
    final (starsPerCell, numCells, columns) = _calculateGrid();
    
    return Column(
      children: [
        // Scale info
        if (starsPerCell > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Each cell = $starsPerCell stars',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ),
        
        // Grid
        AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: List.generate(numCells, (index) {
                // Calculate fill for this cell
                final cellStartStar = index * starsPerCell;
                final cellEndStar = (index + 1) * starsPerCell;
                
                double fill = 0;
                if (widget.progress >= cellEndStar) {
                  fill = 1.0; // Full
                } else if (widget.progress > cellStartStar) {
                  fill = (widget.progress - cellStartStar) / starsPerCell;
                }
                
                // Animate entrance with stagger
                final staggerDelay = index / numCells;
                final animValue = _animController.value;
                final cellAnim = ((animValue - staggerDelay * 0.5) / 0.5).clamp(0.0, 1.0);
                
                return _StarCell(
                  fill: fill,
                  animProgress: cellAnim,
                  index: index,
                );
              }),
            );
          },
        ),
        
        const SizedBox(height: 16),
        
        // Progress text
        Text(
          '${widget.progress} / ${widget.total} ⭐',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6A1B9A),
          ),
        ),
      ],
    );
  }
}

/// Individual star cell with fill animation
class _StarCell extends StatelessWidget {
  final double fill;        // 0.0 to 1.0
  final double animProgress; // Animation progress for entrance
  final int index;

  const _StarCell({
    required this.fill,
    required this.animProgress,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final scale = 0.5 + (animProgress * 0.5);
    final opacity = animProgress;
    
    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
            border: Border.all(
              color: fill > 0 ? Colors.amber : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: ClipOval(
            child: Stack(
              children: [
                // Fill background
                Positioned.fill(
                  child: FractionallySizedBox(
                    alignment: Alignment.bottomCenter,
                    heightFactor: fill * animProgress,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.amber.shade300,
                            Colors.amber.shade500,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Star icon
                Center(
                  child: Icon(
                    fill >= 1.0 ? Icons.star : Icons.star_border,
                    color: fill >= 1.0 ? Colors.white : Colors.grey[400],
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
