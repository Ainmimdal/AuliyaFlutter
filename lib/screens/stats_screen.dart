import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/child_model.dart';
import '../providers/child_provider.dart';

/// Statistics Screen - select a child to view their weekly progress
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  static const Color colorPrimary = Color(0xFF6A1B9A);
  static const Color colorAccent = Color(0xFFAD1457);
  
  ChildModel? _selectedChild;
  DateTime _weekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A0A2E), Color(0xFF2D1F4A)],
          ),
        ),
        child: SafeArea(
          child: Consumer<ChildProvider>(
            builder: (context, provider, _) {
              final children = provider.children;
              
              // Auto-select first child if none selected
              if (_selectedChild == null && children.isNotEmpty) {
                _selectedChild = children.first;
              }
              // Update selected child reference if it exists
              if (_selectedChild != null) {
                _selectedChild = children.where((c) => c.id == _selectedChild!.id).firstOrNull ?? _selectedChild;
              }
              
              return Column(
                children: [
                  _buildHeader(context),
                  if (children.isEmpty)
                    Expanded(child: _buildEmptyState())
                  else ...[
                    _buildChildSelector(children),
                    Expanded(
                      child: _selectedChild == null
                          ? _buildEmptyState()
                          : ListView(
                              padding: const EdgeInsets.all(16),
                              children: [
                                _buildSummaryCard(),
                                const SizedBox(height: 16),
                                _buildWeeklyChart(),
                                const SizedBox(height: 16),
                                _buildAchievements(),
                              ],
                            ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Statistics',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Weekly Progress',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Text('📊', style: TextStyle(fontSize: 24)),
          ),
        ],
      ),
    );
  }

  Widget _buildChildSelector(List<ChildModel> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedChild?.id,
          isExpanded: true,
          dropdownColor: const Color(0xFF2D1F4A),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          hint: const Text('Select a child', style: TextStyle(color: Colors.white54)),
          items: children.map((child) {
            return DropdownMenuItem(
              value: child.id,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: colorPrimary.withOpacity(0.3),
                    child: Text(
                      child.name.isNotEmpty ? child.name[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(child.name),
                  const Spacer(),
                  Text('${child.star} ⭐', style: const TextStyle(color: Colors.amber)),
                ],
              ),
            );
          }).toList(),
          onChanged: (id) {
            setState(() {
              _selectedChild = children.where((c) => c.id == id).firstOrNull;
            });
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_rounded, size: 80, color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'No children added yet',
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    if (_selectedChild == null) return const SizedBox.shrink();
    final child = _selectedChild!;
    final goalsClaimed = child.bigGoals.where((g) => g.isClaimed).length;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorPrimary, colorAccent],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorPrimary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('⭐', '${child.star}', 'Total Stars'),
          Container(width: 1, height: 50, color: Colors.white24),
          _buildStatItem('🏆', '$goalsClaimed', 'Goals'),
          Container(width: 1, height: 50, color: Colors.white24),
          _buildStatItem('🎁', '${child.treatsAvailable}', 'Treats'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _buildWeeklyChart() {
    if (_selectedChild == null) return const SizedBox.shrink();
    
    final weekData = _getWeeklyData();
    final maxY = weekData.isEmpty ? 5.0 : (weekData.reduce((a, b) => a > b ? a : b).toDouble() + 2);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () => setState(() {
                  _weekStart = _weekStart.subtract(const Duration(days: 7));
                }),
              ),
              Text(
                _formatWeekRange(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                onPressed: _weekStart.add(const Duration(days: 7)).isBefore(DateTime.now())
                    ? () => setState(() {
                        _weekStart = _weekStart.add(const Duration(days: 7));
                      })
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                      return BarTooltipItem(
                        '${days[group.x]}: ${rod.toY.toInt()} ⭐',
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        if (value.toInt() < 7) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              days[value.toInt()],
                              style: const TextStyle(color: Colors.white54, fontSize: 12),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 25,
                      getTitlesWidget: (value, meta) {
                        if (value == value.roundToDouble()) {
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(color: Colors.white38, fontSize: 10),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.white.withOpacity(0.1), strokeWidth: 1);
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: weekData[index].toDouble(),
                        color: Colors.amber,
                        width: 20,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxY,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Total this week: ${weekData.reduce((a, b) => a + b)} ⭐',
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<int> _getWeeklyData() {
    if (_selectedChild == null) return List.filled(7, 0);
    final weekData = List.filled(7, 0);
    
    for (final entry in _selectedChild!.starHistory) {
      final daysDiff = entry.date.difference(_weekStart).inDays;
      if (daysDiff >= 0 && daysDiff < 7) {
        weekData[daysDiff] += entry.count;
      }
    }
    
    return weekData;
  }

  String _formatWeekRange() {
    final end = _weekStart.add(const Duration(days: 6));
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${_weekStart.day} ${months[_weekStart.month - 1]} - ${end.day} ${months[end.month - 1]}';
  }

  Widget _buildAchievements() {
    if (_selectedChild == null) return const SizedBox.shrink();
    final child = _selectedChild!;
    final totalStars = child.star;
    final goalsClaimed = child.bigGoals.where((g) => g.isClaimed).length;
    
    final achievements = [
      {'emoji': '🌟', 'title': 'First Star', 'unlocked': totalStars >= 1},
      {'emoji': '⭐', 'title': '10 Stars', 'unlocked': totalStars >= 10},
      {'emoji': '🌠', 'title': '25 Stars', 'unlocked': totalStars >= 25},
      {'emoji': '💫', 'title': '50 Stars', 'unlocked': totalStars >= 50},
      {'emoji': '🏆', 'title': 'First Goal', 'unlocked': goalsClaimed >= 1},
      {'emoji': '👑', 'title': 'Goal Master', 'unlocked': goalsClaimed >= 3},
    ];

    final unlockedCount = achievements.where((a) => a['unlocked'] as bool).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Achievements',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text('$unlockedCount/${achievements.length}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: achievements.map((a) {
              final unlocked = a['unlocked'] as bool;
              return Container(
                width: 100,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: unlocked ? Colors.amber.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: unlocked ? Border.all(color: Colors.amber.withOpacity(0.5)) : null,
                ),
                child: Column(
                  children: [
                    Text(unlocked ? (a['emoji'] as String) : '🔒', style: TextStyle(fontSize: 28, color: unlocked ? null : Colors.white38)),
                    const SizedBox(height: 4),
                    Text(a['title'] as String, style: TextStyle(color: unlocked ? Colors.white : Colors.white38, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
