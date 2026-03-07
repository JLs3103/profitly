import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import 'helpers/database_helper.dart';
import 'screens/home_screen.dart';
import 'screens/transaction_screen.dart';
import 'screens/target_screen.dart';
import 'screens/alert_screen.dart';
import 'screens/login_screen.dart';

/// Global notifier – can be listened from anywhere in the app.
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final savedUsername = prefs.getString('saved_username');

  // Restore saved dark-mode preference
  final isDark = prefs.getBool('dark_mode') ?? false;
  themeModeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;

  Map<String, dynamic>? initialUser;
  if (savedUsername != null) {
    final dbHelper = DatabaseHelper();
    initialUser = await dbHelper.getUserByUsername(savedUsername);
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('id'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('id'),
      child: ProfitlyApp(initialUser: initialUser),
    ),
  );
}

class ProfitlyApp extends StatefulWidget {
  final Map<String, dynamic>? initialUser;
  const ProfitlyApp({super.key, this.initialUser});

  @override
  State<ProfitlyApp> createState() => _ProfitlyAppState();
}

class _ProfitlyAppState extends State<ProfitlyApp> {
  @override
  void initState() {
    super.initState();
    themeModeNotifier.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    themeModeNotifier.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() => setState(() {});

  ThemeData _buildLightTheme() => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1D7A42),
          primary: const Color(0xFF1D7A42),
        ),
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF2F5F4),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1D7A42),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      );

  ThemeData _buildDarkTheme() => ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1D7A42),
          primary: const Color(0xFF1D7A42),
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF166835),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Profitly',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: themeModeNotifier.value,
      home: widget.initialUser != null
          ? MainScreen(user: widget.initialUser)
          : const LoginScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  final Map<String, dynamic>? user;
  const MainScreen({super.key, this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(user: widget.user),
      const TransactionScreen(),
      const TargetScreen(),
      const AlertScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
          selectedItemColor: const Color(0xFF1D7A42),
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_filled),
              label: 'home'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_balance_wallet),
              label: 'transaction'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.track_changes),
              label: 'target'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.notifications),
              label: 'alert'.tr(), // Has a red dot in design, will implement custom icon later if needed
            ),
          ],
        ),
      ),
    );
  }
}
