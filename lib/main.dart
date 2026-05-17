import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'providers/expense_provider.dart';
import 'screens/home_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/all_expenses_screen.dart';
import 'screens/settings_screen.dart';
import 'utils/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.bgDark,
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ExpenseProvider(),
      child: const SpendixApp(),
    ),
  );
}

class SpendixApp extends StatelessWidget {
  const SpendixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spendix',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    AnalyticsScreen(),
    AllExpensesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        backgroundColor: AppTheme.bgDark,
        color: AppTheme.bgCard,
        buttonBackgroundColor: AppTheme.neonPink,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOutCubic,
        height: 60,
        onTap: (index) {
          HapticFeedback.selectionClick();
          setState(() => _currentIndex = index);
        },
        items: [
          _navIcon(Icons.home_rounded, 0),
          _navIcon(Icons.bar_chart_rounded, 1),
          _navIcon(Icons.receipt_long_rounded, 2),
          _navIcon(Icons.settings_rounded, 3),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, int index) {
    return Icon(
      icon,
      size: 28,
      color: _currentIndex == index ? Colors.black : AppTheme.textSecondary,
    );
  }
}
