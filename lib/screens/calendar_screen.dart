import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/supabase_auth.dart';
import '../utils/constants/colors.dart';

// Data model for transaction events (income or expense)
class TransactionEvent {
  TransactionEvent({
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
    required this.isAllDay,
    required this.amount,
    required this.category,
    required this.eventType,
  });

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  double amount;
  String category;
  String eventType; // "income" or "expense"
}

// Data source for SfCalendar
class TransactionEventDataSource extends CalendarDataSource {
  TransactionEventDataSource(List<TransactionEvent> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    final event = appointments![index] as TransactionEvent;
    return event.eventName; // Only eventName for default display
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  CalendarController calendarController = CalendarController();
  final supabase = Supabase.instance.client;
  List<TransactionEvent> _transactionEvents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch transaction events when the screen loads
    _fetchTransactionEvents();
  }

  Future<void> _fetchTransactionEvents() async {
    setState(() {
      _isLoading = true;
    });

    final client = SupabaseAuth.client();
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: You must be logged in to view transactions.'),
          backgroundColor: TColors.errorPrimary,
        ),
      );
      setState(() {
        _isLoading = false;
        _transactionEvents = [];
      });
      return;
    }

    try {
      // Fetch income records
      final incomeResponse = await supabase
          .from('tbl_add_income_data')
          .select()
          .eq('user_uuid', userId);

      final incomeEvents = incomeResponse.map((record) {
        final date = DateTime.parse(record['income_date']?.toString() ??
            DateTime.now().toIso8601String());
        // Ensure non-null strings for eventName and category
        final payeesName = record['payees_name']?.toString() ?? '';
        final incomeCategory =
            record['income_category']?.toString() ?? 'Unknown';
        final eventName = payeesName.isNotEmpty ? payeesName : incomeCategory;
        return TransactionEvent(
          eventName: eventName.isNotEmpty ? eventName : 'Income',
          from: date,
          to: date,
          background: Colors.green[400]!,
          isAllDay: true,
          amount: (record['income_amount'] as num?)?.toDouble() ?? 0.0,
          category: incomeCategory,
          eventType: 'income',
        );
      }).toList();

      // Fetch expense records
      final expenseResponse = await supabase
          .from('tbl_add_expense_data')
          .select()
          .eq('user_uuid', userId);

      final expenseEvents = expenseResponse.map((record) {
        final date = DateTime.parse(record['expense_date']?.toString() ??
            DateTime.now().toIso8601String());
        // Ensure non-null strings for eventName and category
        final payersName = record['payers_name']?.toString() ?? '';
        final expenseCategory =
            record['expense_category']?.toString() ?? 'Unknown';
        final eventName = payersName.isNotEmpty ? payersName : expenseCategory;
        return TransactionEvent(
          eventName: eventName.isNotEmpty ? eventName : 'Expense',
          from: date,
          to: date,
          background: Colors.red[400]!,
          isAllDay: true,
          amount: (record['expense_amount'] as num?)?.toDouble() ?? 0.0,
          category: expenseCategory,
          eventType: 'expense',
        );
      }).toList();

      // Combine transaction events
      setState(() {
        _transactionEvents = [...incomeEvents, ...expenseEvents];
        _isLoading = false;
      });
    } catch (error) {
      // Debug logging
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
        _transactionEvents = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic agenda item height based on text size for readability
    final double agendaItemHeight = 70.0;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black // Black background to match navigation bar
          : Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Calendar
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).brightness == Brightness.dark
                                ? TColors.primaryDark
                                : TColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading calendar...',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? TColors.primaryDark
                                    : TColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : SfCalendar(
                    view: CalendarView.month,
                    initialSelectedDate: DateTime.now(),
                    controller: calendarController,
                    dataSource: TransactionEventDataSource(_transactionEvents),
                    todayHighlightColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? TColors.primaryDark
                            : TColors.tertiary,
                    todayTextStyle: const TextStyle(
                      color: TColors.textWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    selectionDecoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? TColors.primaryDark
                            : TColors.primary,
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      shape: BoxShape.rectangle,
                    ),
                    headerStyle: CalendarHeaderStyle(
                      textStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? TColors.textWhite
                            : TColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? TColors.containerPrimaryDark
                              : TColors.containerSecondary,
                    ),
                    headerHeight: 50,
                    viewHeaderStyle: ViewHeaderStyle(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? TColors.surfaceDark
                              : TColors.secondaryFixed,
                      dayTextStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? TColors.textSecondaryDark
                            : Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    viewHeaderHeight: 40,
                    monthViewSettings: MonthViewSettings(
                      appointmentDisplayMode:
                          MonthAppointmentDisplayMode.indicator,
                      showAgenda: true,
                      dayFormat: 'EEE',
                      monthCellStyle: MonthCellStyle(
                        textStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? TColors.textPrimaryDark
                              : Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        backgroundColor: Colors.transparent,
                        todayBackgroundColor: Theme.of(context).brightness ==
                                Brightness.dark
                            ? TColors.primaryDark.withValues(alpha: 0.2)
                            : TColors.containerSecondary.withValues(alpha: 0.2),
                        trailingDatesTextStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[600]
                              : Colors.grey[400],
                        ),
                        leadingDatesTextStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[600]
                              : Colors.grey[400],
                        ),
                      ),
                      agendaStyle: AgendaStyle(
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? TColors.backgroundDark
                                : Colors.white,
                        appointmentTextStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                        ),
                        dateTextStyle:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : TColors.primary,
                                ),
                        dayTextStyle:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey[400]
                                      : TColors.primary,
                                ),
                      ),
                      agendaItemHeight: agendaItemHeight,
                    ),
                    timeSlotViewSettings: TimeSlotViewSettings(
                      timeIntervalHeight: 60,
                      timeTextStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? TColors.textSecondaryDark
                            : Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      dayFormat: 'EEE',
                      dateFormat: 'd',
                      timeRulerSize: 50,
                      timelineAppointmentHeight: 60,
                    ),
                    appointmentBuilder: (context, calendarAppointmentDetails) {
                      final TransactionEvent event =
                          calendarAppointmentDetails.appointments.first;
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[900]
                              : Colors.white,
                          border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black54
                                  : Colors.grey.withValues(alpha: 0.3),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.eventName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${event.eventType == 'income' ? '+' : '-'} ${event.category}: ₹${event.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: event.eventType == 'income'
                                    ? Colors.green[600]
                                    : Colors.red[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
