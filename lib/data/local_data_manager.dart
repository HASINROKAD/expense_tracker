import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_auth.dart';
import 'user_data_model.dart';

// Enhanced Transaction model with all necessary fields
class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isIncome;
  final String category;
  final String? paymentMethod;
  final String? paymentStatus;
  final String userUuid;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
    required this.category,
    this.paymentMethod,
    this.paymentStatus,
    required this.userUuid,
  });

  factory Transaction.fromIncomeRecord(Map<String, dynamic> record) {
    return Transaction(
      id: record['id']?.toString() ?? '',
      title: record['payees_name']?.toString() ??
          record['income_category']?.toString() ??
          'Income',
      amount: (record['income_amount'] as num?)?.toDouble() ?? 0.0,
      date: DateTime.parse(record['income_date']?.toString() ??
          DateTime.now().toIso8601String()),
      isIncome: true,
      category: record['income_category']?.toString() ?? 'Unknown',
      paymentMethod: record['income_payment_method']?.toString(),
      paymentStatus: record['income_payment_status']?.toString(),
      userUuid: record['user_uuid']?.toString() ?? '',
    );
  }

  factory Transaction.fromExpenseRecord(Map<String, dynamic> record) {
    return Transaction(
      id: record['id']?.toString() ?? '',
      title: record['payers_name']?.toString() ??
          record['expense_category']?.toString() ??
          'Expense',
      amount: (record['expense_amount'] as num?)?.toDouble() ?? 0.0,
      date: DateTime.parse(record['expense_date']?.toString() ??
          DateTime.now().toIso8601String()),
      isIncome: false,
      category: record['expense_category']?.toString() ?? 'Unknown',
      paymentMethod: record['expense_payment_method']?.toString(),
      paymentStatus: record['expense_payment_status']?.toString(),
      userUuid: record['user_uuid']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toIncomeRecord() {
    return {
      'id': id.isEmpty ? null : id,
      'user_uuid': userUuid,
      'income_amount': amount,
      'payees_name': title,
      'income_category': category,
      'income_payment_method': paymentMethod,
      'income_payment_status': paymentStatus,
      'income_date': date.toIso8601String(),
    };
  }

  Map<String, dynamic> toExpenseRecord() {
    return {
      'id': id.isEmpty ? null : id,
      'user_uuid': userUuid,
      'expense_amount': amount,
      'payers_name': title,
      'expense_category': category,
      'expense_payment_method': paymentMethod,
      'expense_payment_status': paymentStatus,
      'expense_date': date.toIso8601String(),
    };
  }
}

// Financial metrics calculated from transactions
class FinancialMetrics {
  final double totalIncome;
  final double totalExpenses;
  final double currentBalance;
  final double todayExpense;
  final double thisWeekIncome;
  final double thisWeekExpense;
  final double thisWeekBalance;
  final double thisMonthIncome;
  final double thisMonthExpense;
  final double thisMonthBalance;
  final double yearToDateIncome;
  final double yearToDateExpense;
  final Map<String, double> incomeCategories;
  final Map<String, double> expenseCategories;

  FinancialMetrics({
    required this.totalIncome,
    required this.totalExpenses,
    required this.currentBalance,
    required this.todayExpense,
    required this.thisWeekIncome,
    required this.thisWeekExpense,
    required this.thisWeekBalance,
    required this.thisMonthIncome,
    required this.thisMonthExpense,
    required this.thisMonthBalance,
    required this.yearToDateIncome,
    required this.yearToDateExpense,
    required this.incomeCategories,
    required this.expenseCategories,
  });
}

// Singleton class for managing local data cache
class LocalDataManager extends ChangeNotifier {
  static final LocalDataManager _instance = LocalDataManager._internal();
  factory LocalDataManager() => _instance;
  LocalDataManager._internal();

  // Local cache variables
  List<Transaction> _transactions = [];
  FinancialMetrics? _metrics;
  UserData? _userData;
  UserPreferences? _userPreferences;
  DateTime? _lastFetchTime;
  DateTime? _lastUserDataFetchTime;
  bool _isLoading = false;
  String? _currentUserId;

  // Cache duration (5 minutes)
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  // Getters for accessing cached data
  List<Transaction> get transactions => List.unmodifiable(_transactions);
  FinancialMetrics? get metrics => _metrics;
  UserData? get userData => _userData;
  UserPreferences? get userPreferences => _userPreferences;
  bool get isLoading => _isLoading;
  bool get hasData => _transactions.isNotEmpty;
  bool get hasUserData => _userData != null;

  // Check if cache is valid
  bool get isCacheValid {
    if (_lastFetchTime == null) return false;
    return DateTime.now().difference(_lastFetchTime!) < _cacheValidDuration;
  }

  // Check if user data cache is valid
  bool get isUserDataCacheValid {
    if (_lastUserDataFetchTime == null) return false;
    return DateTime.now().difference(_lastUserDataFetchTime!) <
        _cacheValidDuration;
  }

  // Get current user ID
  String? get currentUserId {
    final client = SupabaseAuth.client();
    return client.auth.currentUser?.id;
  }

  // Initialize and fetch data if needed
  Future<void> initialize() async {
    final userId = currentUserId;
    if (userId == null) return;

    // If user changed, clear cache
    if (_currentUserId != userId) {
      clearCache();
      _currentUserId = userId;
    }

    // Fetch transaction data if cache is invalid or empty
    if (!isCacheValid || _transactions.isEmpty) {
      await fetchAllData();
    }

    // Fetch user data if cache is invalid or empty
    if (!isUserDataCacheValid || _userData == null) {
      await fetchUserData();
    }

    // Load user preferences from local storage
    await _loadUserPreferences();
  }

  // Fetch all transaction data from Supabase
  Future<void> fetchAllData({bool forceRefresh = false}) async {
    final userId = currentUserId;
    if (userId == null) return;

    // Skip if cache is valid and not forcing refresh
    if (!forceRefresh && isCacheValid && _transactions.isNotEmpty) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final supabase = Supabase.instance.client;

      // Fetch income records
      final incomeResponse = await supabase
          .from('tbl_add_income_data')
          .select()
          .eq('user_uuid', userId)
          .order('income_date', ascending: false);

      final incomeTransactions = incomeResponse
          .map((record) => Transaction.fromIncomeRecord(record))
          .where((t) => t.id.isNotEmpty)
          .toList();

      // Fetch expense records
      final expenseResponse = await supabase
          .from('tbl_add_expense_data')
          .select()
          .eq('user_uuid', userId)
          .order('expense_date', ascending: false);

      final expenseTransactions = expenseResponse
          .map((record) => Transaction.fromExpenseRecord(record))
          .where((t) => t.id.isNotEmpty)
          .toList();

      // Combine and sort transactions
      _transactions = [...incomeTransactions, ...expenseTransactions];
      _transactions.sort((a, b) => b.date.compareTo(a.date));

      // Calculate financial metrics
      _calculateMetrics();

      _lastFetchTime = DateTime.now();
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print('Error fetching data: $error');
      }
      rethrow;
    }
  }

  // Calculate financial metrics from cached transactions
  void _calculateMetrics() {
    if (_transactions.isEmpty) {
      _metrics = null;
      return;
    }

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final monthStart = DateTime(now.year, now.month, 1);
    final yearStart = DateTime(now.year, 1, 1);

    final incomeList = _transactions.where((t) => t.isIncome).toList();
    final expenseList = _transactions.where((t) => !t.isIncome).toList();

    // Calculate totals
    final totalIncome = incomeList.fold(0.0, (sum, t) => sum + t.amount);
    final totalExpenses = expenseList.fold(0.0, (sum, t) => sum + t.amount);

    // Calculate time-based metrics
    final todayExpense = expenseList
        .where((t) =>
            t.date.isAfter(todayStart) || t.date.isAtSameMomentAs(todayStart))
        .fold(0.0, (sum, t) => sum + t.amount);

    final thisWeekIncome = incomeList
        .where((t) =>
            t.date.isAfter(weekStart) || t.date.isAtSameMomentAs(weekStart))
        .fold(0.0, (sum, t) => sum + t.amount);

    final thisWeekExpense = expenseList
        .where((t) =>
            t.date.isAfter(weekStart) || t.date.isAtSameMomentAs(weekStart))
        .fold(0.0, (sum, t) => sum + t.amount);

    final thisMonthIncome = incomeList
        .where((t) =>
            t.date.isAfter(monthStart) || t.date.isAtSameMomentAs(monthStart))
        .fold(0.0, (sum, t) => sum + t.amount);

    final thisMonthExpense = expenseList
        .where((t) =>
            t.date.isAfter(monthStart) || t.date.isAtSameMomentAs(monthStart))
        .fold(0.0, (sum, t) => sum + t.amount);

    final yearToDateIncome = incomeList
        .where((t) =>
            t.date.isAfter(yearStart) || t.date.isAtSameMomentAs(yearStart))
        .fold(0.0, (sum, t) => sum + t.amount);

    final yearToDateExpense = expenseList
        .where((t) =>
            t.date.isAfter(yearStart) || t.date.isAtSameMomentAs(yearStart))
        .fold(0.0, (sum, t) => sum + t.amount);

    // Calculate category-wise totals
    final Map<String, double> incomeCategories = {};
    for (var transaction in incomeList) {
      incomeCategories[transaction.category] =
          (incomeCategories[transaction.category] ?? 0.0) + transaction.amount;
    }

    final Map<String, double> expenseCategories = {};
    for (var transaction in expenseList) {
      expenseCategories[transaction.category] =
          (expenseCategories[transaction.category] ?? 0.0) + transaction.amount;
    }

    _metrics = FinancialMetrics(
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      currentBalance: totalIncome - totalExpenses,
      todayExpense: todayExpense,
      thisWeekIncome: thisWeekIncome,
      thisWeekExpense: thisWeekExpense,
      thisWeekBalance: thisWeekIncome - thisWeekExpense,
      thisMonthIncome: thisMonthIncome,
      thisMonthExpense: thisMonthExpense,
      thisMonthBalance: thisMonthIncome - thisMonthExpense,
      yearToDateIncome: yearToDateIncome,
      yearToDateExpense: yearToDateExpense,
      incomeCategories: incomeCategories,
      expenseCategories: expenseCategories,
    );
  }

  // Add new transaction to cache and database
  Future<Transaction> addTransaction(Transaction transaction) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final supabase = Supabase.instance.client;

    try {
      final table =
          transaction.isIncome ? 'tbl_add_income_data' : 'tbl_add_expense_data';
      final data = transaction.isIncome
          ? transaction.toIncomeRecord()
          : transaction.toExpenseRecord();

      // Remove id for new records
      data.remove('id');

      final response =
          await supabase.from(table).insert(data).select().single();

      // Create updated transaction with new ID
      final newTransaction = transaction.isIncome
          ? Transaction.fromIncomeRecord(response)
          : Transaction.fromExpenseRecord(response);

      // Add to local cache
      _transactions.insert(0, newTransaction);
      _transactions.sort((a, b) => b.date.compareTo(a.date));

      // Recalculate metrics
      _calculateMetrics();
      notifyListeners();

      return newTransaction;
    } catch (error) {
      if (kDebugMode) {
        print('Error adding transaction: $error');
      }
      rethrow;
    }
  }

  // Update existing transaction in cache and database
  Future<Transaction> updateTransaction(Transaction transaction) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final supabase = Supabase.instance.client;

    try {
      final table =
          transaction.isIncome ? 'tbl_add_income_data' : 'tbl_add_expense_data';
      final data = transaction.isIncome
          ? transaction.toIncomeRecord()
          : transaction.toExpenseRecord();

      await supabase.from(table).update(data).eq('id', transaction.id);

      // Update in local cache
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = transaction;
        _transactions.sort((a, b) => b.date.compareTo(a.date));

        // Recalculate metrics
        _calculateMetrics();
        notifyListeners();
      }

      return transaction;
    } catch (error) {
      if (kDebugMode) {
        print('Error updating transaction: $error');
      }
      rethrow;
    }
  }

  // Delete transaction from cache and database
  Future<void> deleteTransaction(String transactionId) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    // Find transaction in cache
    final transaction = _transactions.firstWhere(
      (t) => t.id == transactionId,
      orElse: () => throw Exception('Transaction not found'),
    );

    final supabase = Supabase.instance.client;

    try {
      final table =
          transaction.isIncome ? 'tbl_add_income_data' : 'tbl_add_expense_data';
      await supabase.from(table).delete().eq('id', transactionId);

      // Remove from local cache
      _transactions.removeWhere((t) => t.id == transactionId);

      // Recalculate metrics
      _calculateMetrics();
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Error deleting transaction: $error');
      }
      rethrow;
    }
  }

  // Get transactions filtered by various criteria
  List<Transaction> getTransactions({
    bool? isIncome,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) {
    var filtered = _transactions.where((transaction) {
      if (isIncome != null && transaction.isIncome != isIncome) return false;
      if (category != null && transaction.category != category) return false;
      if (startDate != null && transaction.date.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && transaction.date.isAfter(endDate)) return false;
      return true;
    }).toList();

    if (limit != null && limit > 0) {
      filtered = filtered.take(limit).toList();
    }

    return filtered;
  }

  // Get transactions for today
  List<Transaction> getTodayTransactions() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    return getTransactions(startDate: todayStart, endDate: todayEnd);
  }

  // Get transactions for this week
  List<Transaction> getThisWeekTransactions() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    return getTransactions(startDate: weekStart);
  }

  // Get transactions for this month
  List<Transaction> getThisMonthTransactions() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    return getTransactions(startDate: monthStart);
  }

  // Get recent transactions
  List<Transaction> getRecentTransactions({int limit = 10}) {
    return getTransactions(limit: limit);
  }

  // Get categories with transaction counts
  Map<String, int> getIncomeCategories() {
    final Map<String, int> categories = {};
    for (var transaction in _transactions.where((t) => t.isIncome)) {
      categories[transaction.category] =
          (categories[transaction.category] ?? 0) + 1;
    }
    return categories;
  }

  Map<String, int> getExpenseCategories() {
    final Map<String, int> categories = {};
    for (var transaction in _transactions.where((t) => !t.isIncome)) {
      categories[transaction.category] =
          (categories[transaction.category] ?? 0) + 1;
    }
    return categories;
  }

  // Clear cache (useful for logout or user change)
  void clearCache() {
    _transactions.clear();
    _metrics = null;
    _userData = null;
    _userPreferences = null;
    _lastFetchTime = null;
    _lastUserDataFetchTime = null;
    _currentUserId = null;
    notifyListeners();
  }

  // Force refresh data from database
  Future<void> refreshData() async {
    await fetchAllData(forceRefresh: true);
  }

  // Get cache status info
  Map<String, dynamic> getCacheInfo() {
    return {
      'transactionCount': _transactions.length,
      'lastFetchTime': _lastFetchTime?.toIso8601String(),
      'lastUserDataFetchTime': _lastUserDataFetchTime?.toIso8601String(),
      'isCacheValid': isCacheValid,
      'isUserDataCacheValid': isUserDataCacheValid,
      'isLoading': _isLoading,
      'currentUserId': _currentUserId,
      'hasUserData': hasUserData,
    };
  }

  // ============================================================================
  // USER DATA MANAGEMENT METHODS
  // ============================================================================

  /// Fetch user data from Supabase
  Future<void> fetchUserData({bool forceRefresh = false}) async {
    final userId = currentUserId;
    if (userId == null) return;

    // Skip if cache is valid and not forcing refresh
    if (!forceRefresh && isUserDataCacheValid && _userData != null) {
      return;
    }

    try {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('tbl_user_data')
          .select()
          .eq('user_uuid', userId)
          .maybeSingle();

      if (response != null) {
        _userData = UserData.fromSupabaseRecord(response);
      } else {
        // Create empty user data if none exists
        _userData = UserData.empty(userId);
      }

      _lastUserDataFetchTime = DateTime.now();
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching user data: $error');
      }
      // Create empty user data on error
      _userData = UserData.empty(userId);
      notifyListeners();
    }
  }

  /// Save or update user data
  Future<UserData> saveUserData(UserData userData) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final supabase = Supabase.instance.client;

    try {
      final data = userData.toSupabaseRecord();
      data['user_uuid'] = userId; // Ensure correct user UUID

      UserData updatedUserData;

      if (userData.id.isEmpty) {
        // Insert new user data
        data.remove('id'); // Let database generate ID
        final response =
            await supabase.from('tbl_user_data').insert(data).select().single();

        updatedUserData = UserData.fromSupabaseRecord(response);
      } else {
        // Update existing user data
        await supabase.from('tbl_user_data').update(data).eq('id', userData.id);

        updatedUserData = userData;
      }

      // Update local cache
      _userData = updatedUserData;
      _lastUserDataFetchTime = DateTime.now();
      notifyListeners();

      return updatedUserData;
    } catch (error) {
      if (kDebugMode) {
        print('Error saving user data: $error');
      }
      rethrow;
    }
  }

  /// Load user preferences from local storage
  Future<void> _loadUserPreferences() async {
    final userId = currentUserId;
    if (userId == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final prefsJson = prefs.getString('user_preferences_$userId');

      if (prefsJson != null) {
        final Map<String, dynamic> data = jsonDecode(prefsJson);
        _userPreferences = UserPreferences.fromJson(data);
      } else {
        // Create default preferences
        _userPreferences = UserPreferences.defaultForUser(userId);
        await _saveUserPreferences();
      }

      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Error loading user preferences: $error');
      }
      // Create default preferences on error
      _userPreferences = UserPreferences.defaultForUser(userId);
      notifyListeners();
    }
  }

  /// Save user preferences to local storage
  Future<void> _saveUserPreferences() async {
    if (_userPreferences == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final prefsJson = jsonEncode(_userPreferences!.toJson());
      await prefs.setString(
          'user_preferences_${_userPreferences!.userUuid}', prefsJson);
    } catch (error) {
      if (kDebugMode) {
        print('Error saving user preferences: $error');
      }
    }
  }

  /// Update user preferences
  Future<void> updateUserPreferences(UserPreferences preferences) async {
    _userPreferences = preferences;
    await _saveUserPreferences();
    notifyListeners();
  }

  /// Get user statistics from transaction data
  Map<String, dynamic> getUserStatistics() {
    final metrics = _metrics;
    if (metrics == null) {
      return {
        'totalTransactions': 0,
        'categoriesCreated': 0,
        'daysActive': 0,
        'totalIncome': 0.0,
        'totalExpenses': 0.0,
        'currentBalance': 0.0,
      };
    }

    final incomeCategories = metrics.incomeCategories.keys.length;
    final expenseCategories = metrics.expenseCategories.keys.length;
    final totalCategories = incomeCategories + expenseCategories;

    // Calculate days active (days with transactions)
    final uniqueDays = _transactions
        .map((t) => DateTime(t.date.year, t.date.month, t.date.day))
        .toSet()
        .length;

    return {
      'totalTransactions': _transactions.length,
      'categoriesCreated': totalCategories,
      'daysActive': uniqueDays,
      'totalIncome': metrics.totalIncome,
      'totalExpenses': metrics.totalExpenses,
      'currentBalance': metrics.currentBalance,
      'incomeCategories': incomeCategories,
      'expenseCategories': expenseCategories,
    };
  }

  /// Refresh user data from database
  Future<void> refreshUserData() async {
    await fetchUserData(forceRefresh: true);
  }
}
