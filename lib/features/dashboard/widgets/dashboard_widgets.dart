import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/activity_model.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, 
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
          ),
          Text(label, 
            style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)
          ),
        ],
      ),
    );
  }
}

class PerformanceChart extends StatelessWidget {
  final Color primaryColor;

  const PerformanceChart({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Weekly Throughput", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Icon(Icons.trending_up_rounded, color: primaryColor, size: 20),
            ],
          ),
          const SizedBox(height: 25),
          const SizedBox(
            height: 180,
            child: BarChartSample(),
          ),
        ],
      ),
    );
  }
}

class StockDistributionCard extends StatelessWidget {
  final Color primaryColor;

  const StockDistributionCard({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Stock Distribution", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: 180,
                  child: Stack(
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 6,
                          centerSpaceRadius: 40,
                          sections: [
                            PieChartSectionData(
                              color: primaryColor.withValues(alpha: 0.85), 
                              value: 60, 
                              radius: 25, 
                              showTitle: false,
                              badgeWidget: _buildBadge("60%", context),
                              badgePositionPercentageOffset: 1.15,
                            ),
                            PieChartSectionData(
                              color: const Color(0xFF4A4E69), 
                              value: 25, 
                              radius: 25, 
                              showTitle: false,
                              badgeWidget: _buildBadge("25%", context),
                              badgePositionPercentageOffset: 1.15,
                            ),
                            PieChartSectionData(
                              color: const Color(0xFF9A4C55), 
                              value: 15, 
                              radius: 25, 
                              showTitle: false,
                              badgeWidget: _buildBadge("15%", context),
                              badgePositionPercentageOffset: 1.15,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("1.2k", style: TextStyle(
                              fontSize: 26, 
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                              height: 1.1,
                            )),
                            const Text("Total", style: TextStyle(
                              fontSize: 12, 
                              color: Colors.grey, 
                              fontWeight: FontWeight.w500,
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DistributionLegendItem(color: primaryColor.withValues(alpha: 0.85), label: "In Stock", value: "60%"),
                    const SizedBox(height: 15),
                    DistributionLegendItem(color: const Color(0xFF4A4E69), label: "Reserved", value: "25%"),
                    const SizedBox(height: 15),
                    DistributionLegendItem(color: const Color(0xFF9A4C55), label: "Damaged", value: "15%"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildBadge(String text, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D3A) : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}

class DistributionLegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  const DistributionLegendItem({super.key, required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            Text(value, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}

class ActivityTile extends StatelessWidget {
  final ActivityModel activity;
  final Color primaryColor;

  const ActivityTile({super.key, required this.activity, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.inventory_2_outlined, color: primaryColor, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(activity.time, style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        ],
      ),
    );
  }
}

class QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const QuickActionItem({super.key, required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class BarChartSample extends StatelessWidget {
  const BarChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => primaryColor.withValues(alpha: 0.15),
            tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${(rod.toY / 20 * 100).round()}%',
                TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
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
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                if (value.toInt() < 0 || value.toInt() >= days.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(days[value.toInt()], style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500)),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          _group(0, 8, primaryColor),
          _group(1, 14, primaryColor),
          _group(2, 11, primaryColor),
          _group(3, 17, primaryColor),
          _group(4, 12, primaryColor),
          _group(5, 9, primaryColor),
          _group(6, 6, primaryColor),
        ],
      ),
    );
  }

  BarChartGroupData _group(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color.withValues(alpha: 0.8),
          width: 12,
          borderRadius: BorderRadius.circular(6),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: color.withValues(alpha: 0.05),
          ),
        ),
      ],
    );
  }
}
