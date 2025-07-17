import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../data/chart_data.dart';
import '../data/supabase_auth.dart';
import '../utils/constants/colors.dart';

enum ChartFilter { income, expense }

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  List<ChartData> _chartData = [];
  ChartFilter _selectedFilter = ChartFilter.expense; // Default to expense
  String _selectedPeriod = 'All Time';
  bool _isLoading = true;
  double _averageAmount = 0.0; // Store average for ring chart

  // Predefined colors that suit the theme
  static const List<Color> _themeColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blueAccent,
    Colors.blueGrey,
    Colors.purpleAccent,
    Colors.purple,
  ];

  // Time period options for dropdown
  final List<String> _periodOptions = [
    'All Time',
    'This Year',
    'This Month',
    'This Week',
  ];

  @override
  void initState() {
    super.initState();
    _fetchTransactionData();
  }

  Future<void> _fetchTransactionData() async {
    setState(() {
      _isLoading = true;
    });

    final client = SupabaseAuth.client();
    final userId = client.auth.currentUser?.id;
    final supabase = Supabase.instance.client;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: You must be logged in to view transactions.'),
          backgroundColor: TColors.errorPrimary,
        ),
      );
      setState(() {
        _isLoading = false;
        _chartData = [ChartData('No Data', 0, Colors.grey, 'Unknown')];
        _averageAmount = 0.0;
      });
      return;
    }

    try {
      // Fetch income records
      final incomeResponse = await supabase
          .from('tbl_add_income_data')
          .select()
          .eq('user_uuid', userId);

      final incomeData = incomeResponse.map((record) {
        return ChartData(
          record['income_date'] as String,
          (record['income_amount'] as num?)?.toDouble() ?? 0.0,
          Colors.green[400]!, // Fixed for bar chart
          record['income_category'] as String? ?? 'Unknown',
        );
      }).toList();

      // Fetch expense records
      final expenseResponse = await supabase
          .from('tbl_add_expense_data')
          .select()
          .eq('user_uuid', userId);

      final expenseData = expenseResponse.map((record) {
        return ChartData(
          record['expense_date'] as String,
          (record['expense_amount'] as num?)?.toDouble() ?? 0.0,
          Colors.red[400]!, // Fixed for bar chart
          record['expense_category'] as String? ?? 'Unknown',
        );
      }).toList();

      // Combine and update chart data
      setState(() {
        _chartData = [...incomeData, ...expenseData];
        _isLoading = false;
        _averageAmount = _chartData.isEmpty
            ? 0.0
            : _chartData.fold(0.0, (sum, data) => sum + data.value) /
                _chartData.length;
      });

      if (_chartData.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No transactions found.'),
              backgroundColor: TColors.primary,
            ),
          );
        }
        setState(() {
          _chartData = [ChartData('No Data', 0, Colors.grey, 'Unknown')];
          _averageAmount = 0.0;
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching transactions: $error'),
            backgroundColor: TColors.errorPrimary,
          ),
        );
      }
      setState(() {
        _isLoading = false;
        _chartData = [ChartData('No Data', 0, Colors.grey, 'Unknown')];
        _averageAmount = 0.0;
      });
    }
  }

  // Filter and aggregate chart data based on selected filter and period
  List<ChartData> _getFilteredChartData({required bool forBarChart}) {
    List<ChartData> filteredData = _chartData;

    // Filter by Income/Expense
    if (_selectedFilter == ChartFilter.income) {
      filteredData = filteredData
          .where((data) => data.color == Colors.green[400])
          .toList();
    } else if (_selectedFilter == ChartFilter.expense) {
      filteredData =
          filteredData.where((data) => data.color == Colors.red[400]).toList();
    }

    // Filter by time period
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final startOfMonth = DateTime(now.year, now.month, 1);
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    if (_selectedPeriod == 'This Year') {
      filteredData = filteredData.where((data) {
        try {
          final date = DateTime.parse(data.date);
          return date.isAfter(startOfYear) ||
              date.isAtSameMomentAs(startOfYear);
        } catch (e) {
          return false; // Skip invalid dates
        }
      }).toList();
    } else if (_selectedPeriod == 'This Month') {
      filteredData = filteredData.where((data) {
        try {
          final date = DateTime.parse(data.date);
          return date.isAfter(startOfMonth) ||
              date.isAtSameMomentAs(startOfMonth);
        } catch (e) {
          return false; // Skip invalid dates
        }
      }).toList();
    } else if (_selectedPeriod == 'This Week') {
      filteredData = filteredData.where((data) {
        try {
          final date = DateTime.parse(data.date);
          return date.isAfter(startOfWeek) ||
              date.isAtSameMomentAs(startOfWeek);
        } catch (e) {
          return false; // Skip invalid dates
        }
      }).toList();
    }

    // Aggregate data
    List<ChartData> aggregatedData;
    if (forBarChart) {
      // Aggregate by date for bar chart
      final Map<String, double> dateValueMap = {};
      for (var data in filteredData) {
        final dateKey = data.date;
        dateValueMap[dateKey] = (dateValueMap[dateKey] ?? 0.0) + data.value;
      }
      aggregatedData = dateValueMap.entries.map((entry) {
        return ChartData(
          entry.key,
          entry.value,
          _selectedFilter == ChartFilter.income
              ? Colors.green[400]!
              : Colors.red[400]!,
          'Total', // Category not needed for bar chart
        );
      }).toList();
    } else {
      // Aggregate by category for doughnut chart
      final Map<String, double> categoryValueMap = {};
      for (var data in filteredData) {
        final categoryKey = data.category;
        categoryValueMap[categoryKey] =
            (categoryValueMap[categoryKey] ?? 0.0) + data.value;
      }
      int index = 0;
      aggregatedData = categoryValueMap.entries.map((entry) {
        final color = _themeColors[index % _themeColors.length];
        index++;
        return ChartData(
          '', // Date not needed
          entry.value,
          color, // Cycle through theme colors
          entry.key,
        );
      }).toList();
    }

    // Calculate average for filtered data
    _averageAmount = aggregatedData.isEmpty
        ? 0.0
        : aggregatedData.fold(0.0, (sum, data) => sum + data.value) /
            aggregatedData.length;

    return aggregatedData.isEmpty
        ? [ChartData('No Data', 0, Colors.grey, 'Unknown')]
        : aggregatedData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(TColors.primary),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 16,
                      color: TColors.primary,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Dropdown and Segmented Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Dropdown Menu
                      Container(
                        decoration: BoxDecoration(
                          color: TColors.containerSecondary,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: TColors.primary, width: 1),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButton<String>(
                          value: _selectedPeriod,
                          items: _periodOptions.map((String period) {
                            return DropdownMenuItem<String>(
                              value: period,
                              child: Text(
                                period,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      fontSize: 14,
                                      color: TColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedPeriod = newValue;
                              });
                            }
                          },
                          dropdownColor: TColors.containerSecondary,
                          borderRadius: BorderRadius.circular(8),
                          underline: const SizedBox(),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: TColors.primary,
                          ),
                        ),
                      ),
                      // Segmented Button
                      SizedBox(
                        width: 240,
                        child: SegmentedButton<ChartFilter>(
                          style: SegmentedButton.styleFrom(
                            selectedBackgroundColor: TColors.containerSecondary,
                            textStyle: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontSize: 14),
                          ),
                          segments: const <ButtonSegment<ChartFilter>>[
                            ButtonSegment<ChartFilter>(
                              value: ChartFilter.expense,
                              label: Text('Expense'),
                            ),
                            ButtonSegment<ChartFilter>(
                              value: ChartFilter.income,
                              label: Text('Income'),
                            ),
                          ],
                          selected: <ChartFilter>{_selectedFilter},
                          onSelectionChanged: (Set<ChartFilter> newSelection) {
                            setState(() {
                              _selectedFilter = newSelection.first;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Charts
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWideScreen = constraints.maxWidth > 600;
                    final isHeightConstrained = constraints.maxHeight.isFinite;
                    final fallbackHeight = 300.0;
                    final barChartHeight = isHeightConstrained
                        ? constraints.maxHeight * 0.45
                        : fallbackHeight;
                    final ringChartHeight = isHeightConstrained
                        ? constraints.maxHeight * 0.55
                        : fallbackHeight * 1.2;

                    return isWideScreen
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child:
                                    _buildBarChart(constraints, barChartHeight),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildRingChart(
                                    constraints, ringChartHeight),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              _buildBarChart(constraints, barChartHeight),
                              const SizedBox(height: 16),
                              _buildRingChart(constraints, ringChartHeight),
                            ],
                          );
                  },
                ),
              ],
            ),
    );
  }

  Widget _buildBarChart(BoxConstraints constraints, double chartHeight) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: TColors.containerPrimary,
      ),
      height: chartHeight.clamp(200.0, 400.0),
      padding: const EdgeInsets.all(8),
      child: SfCartesianChart(
        title: ChartTitle(
          text: _selectedFilter == ChartFilter.income ? 'Income' : 'Expense',
          textStyle: Theme.of(context).textTheme.titleMedium,
        ),
        primaryXAxis: const CategoryAxis(
          labelStyle: TextStyle(color: TColors.primary),
        ),
        primaryYAxis: const NumericAxis(
          labelStyle: TextStyle(color: TColors.primary),
        ),
        legend: const Legend(
          isVisible: false, // Remove Series 0 button
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          format: 'point.x : ₹point.y',
          textStyle: const TextStyle(color: TColors.textWhite),
          borderColor: TColors.hintTextLight,
          borderWidth: 1,
          color: TColors.hintTextLight,
        ),
        series: [
          ColumnSeries<ChartData, String>(
            dataSource: _getFilteredChartData(forBarChart: true),
            xValueMapper: (ChartData data, _) =>
                DateFormat('MMM dd').format(DateTime.parse(data.date)),
            yValueMapper: (ChartData data, _) => data.value,
            pointColorMapper: (ChartData data, _) => data.color,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRingChart(BoxConstraints constraints, double chartHeight) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: TColors.containerPrimary,
      ),
      height: chartHeight.clamp(240.0, 480.0),
      padding: const EdgeInsets.all(8),
      child: SfCircularChart(
        title: ChartTitle(
          text: _selectedFilter == ChartFilter.income ? 'Income' : 'Expense',
          textStyle: Theme.of(context).textTheme.titleMedium,
        ),
        legend: Legend(
          isVisible: true,
          textStyle: TextStyle(color: TColors.primary),
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          format: 'point.x : ₹point.y',
          textStyle: TextStyle(color: TColors.textWhite),
          borderColor: TColors.hintTextLight,
          borderWidth: 1,
          color: TColors.hintTextLight,
        ),
        annotations: [
          CircularChartAnnotation(
            widget: Text(
              'Avg: ₹${_averageAmount.toStringAsFixed(2)}',
              style: TextStyle(
                color: TColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        series: [
          DoughnutSeries<ChartData, String>(
            dataSource: _getFilteredChartData(forBarChart: false),
            xValueMapper: (ChartData data, _) => data.category,
            yValueMapper: (ChartData data, _) => data.value,
            pointColorMapper: (ChartData data, _) => data.color,
            dataLabelMapper: (ChartData data, _) {
              final total = _getFilteredChartData(forBarChart: false)
                  .fold<double>(0.0, (sum, item) => sum + item.value);
              final percentage = total > 0
                  ? (data.value / total * 100).toStringAsFixed(1)
                  : '0.0';
              return '${data.category}: $percentage%';
            },
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              textStyle: Theme.of(context).textTheme.titleMedium,
              labelIntersectAction: LabelIntersectAction.shift,
              useSeriesColor: true,
            ),
            explode: true,
            strokeWidth: 1.0,
            strokeColor: TColors.primary,
          ),
        ],
      ),
    );
  }
}
