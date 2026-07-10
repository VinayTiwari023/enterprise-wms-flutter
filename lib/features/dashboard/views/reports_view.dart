import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../settings/viewmodels/theme_view_model.dart';
import '../viewmodels/reports_view_model.dart';
import '../../../core/utils/base_view_model.dart';

class ReportsView extends ConsumerWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeVM = ref.watch(themeViewModelProvider);
    final viewModel = ref.watch(reportsViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Reports & Analytics", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.tune_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.file_download_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthlyOverview(context, primaryColor),
            const SizedBox(height: 30),
            const Text("Inventory Turnover", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildTurnoverChart(context, primaryColor),
            const SizedBox(height: 30),
            const Text("Key Performance Indicators", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildKPIGrid(context),
            const SizedBox(height: 30),
            const Text("Recent Reports", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            viewModel.status == ViewStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: viewModel.recentReports.map((report) => _buildReportTile(context, report['title']!, report['date']!)).toList(),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyOverview(BuildContext context, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.analytics_outlined, color: primaryColor, size: 24),
              const SizedBox(width: 10),
              const Text("Monthly Overview", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildOverviewItem("Total Orders", "1,284", "+12%", Colors.green),
              _buildOverviewItem("Accuracy", "98.5%", "+0.4%", Colors.green),
              _buildOverviewItem("Efficiency", "84%", "-2%", Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(String label, String value, String change, Color changeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(change, style: TextStyle(color: changeColor, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTurnoverChart(BuildContext context, Color primaryColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 250,
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
        boxShadow: isDark ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          minY: 2.8,
          maxY: 6.5,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 0.5,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'];
                  if (value.toInt() >= 0 && value.toInt() < months.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        months[value.toInt()], 
                        style: TextStyle(color: isDark ? Colors.grey : Colors.grey.shade600, fontSize: 10)
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
                interval: 0.5,
                getTitlesWidget: (value, meta) {
                  if (value == 2.8 || value == 3 || value == 3.5 || value == 4 || value == 4.5 || value == 5 || value == 5.5 || value == 6 || value == 6.5) {
                    return Text(
                      value.toString(), 
                      style: TextStyle(color: isDark ? Colors.grey : Colors.grey.shade600, fontSize: 10)
                    );
                  }
                  return const SizedBox();
                },
                reservedSize: 30,
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 3),
                const FlSpot(1, 3.5),
                const FlSpot(2, 2.8),
                const FlSpot(3, 4.2),
                const FlSpot(4, 3.8),
                const FlSpot(5, 5.2),
                const FlSpot(6, 4.8),
                const FlSpot(7, 5.5),
                const FlSpot(8, 6.2),
                const FlSpot(9, 6.5),
              ],
              isCurved: true,
              curveSmoothness: 0.35,
              color: primaryColor,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.3),
                    primaryColor.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPIGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.3,
      children: [
        _buildKPICard(context, Icons.check_circle_outline, "99.2%", "Pick Accuracy", Colors.blue),
        _buildKPICard(context, Icons.inventory_2_outlined, "45/hr", "Pack Rate", Colors.orange),
        _buildKPICard(context, Icons.timer_outlined, "2.4 hrs", "Dock to Stock", Colors.purple),
        _buildKPICard(context, Icons.sync_rounded, "1.5 days", "Order Cycle", Colors.teal),
      ],
    );
  }

  Widget _buildKPICard(BuildContext context, IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildReportTile(BuildContext context, String title, String date) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.picture_as_pdf_outlined, color: Colors.redAccent, size: 24),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text("Generated on $date", style: const TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert, size: 20)),
    );
  }
}
