import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/logs_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/scammers_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/call_simulation_screen.dart';
import 'screens/spam_analysis_screen.dart';
import 'screens/call_trap_screen.dart';
import 'screens/intelligence_report_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HIVE - Scam Detection',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/dashboard': (context) => const MainApp(),
      },
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const LogsScreen(),
    const CallSimulationScreen(),
    const SpamAnalysisScreen(),
    const CallTrapScreen(),
    const ScammersScreen(),
    const AlertsScreen(),
    const IntelligenceReportScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: 'Logs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.phone_in_talk_outlined),
              activeIcon: Icon(Icons.phone_in_talk),
              label: 'Call Sim',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shield_outlined),
              activeIcon: Icon(Icons.shield),
              label: 'Analyze',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.phone_missed_outlined),
              activeIcon: Icon(Icons.phone_missed),
              label: 'Call Trap',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_off_outlined),
              activeIcon: Icon(Icons.person_off),
              label: 'Scammers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.warning_outlined),
              activeIcon: Icon(Icons.warning),
              label: 'Alerts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights_outlined),
              activeIcon: Icon(Icons.insights),
              label: 'Intel',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
    );
  }
}
