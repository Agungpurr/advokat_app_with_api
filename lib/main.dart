import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = AuthService();
  await authService.initialize();

  runApp(const AdvokatApp());
}

class AdvokatApp extends StatelessWidget {
  const AdvokatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advokat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF1E3A8A),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.black, // AppBar hitam
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFFFFD700), // teks gold
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(
            color: Color(0xFFFFD700), // ikon gold
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    final isLoggedIn = await _authService.isLoggedIn();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isLoggedIn
              ? const HomeScreen()
              : const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF1E1E1E)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.gavel, size: 100, color: Color(0xFFFFD700)),
              SizedBox(height: 24),
              Text(
                'Advokat App',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFD700),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Monitoring Kinerja Advokat',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              SizedBox(height: 48),
              CircularProgressIndicator(color: Color(0xFFFFD700)),
            ],
          ),
        ),
      ),
    );
  }
}
