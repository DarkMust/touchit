import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'screens/legal_hub_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const TappyShapeApp());
}

class TappyShapeApp extends StatelessWidget {
  const TappyShapeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TappyShape',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        fontFamily: 'Poppins',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Poppins',
      ),
      home: const ConsentGate(child: HomeScreen()),
    );
  }
}

class ConsentGate extends StatefulWidget {
  final Widget child;
  const ConsentGate({required this.child, super.key});

  @override
  State<ConsentGate> createState() => _ConsentGateState();
}

class _ConsentGateState extends State<ConsentGate> {
  bool _accepted = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkConsent();
  }

  Future<void> _checkConsent() async {
    final prefs = await SharedPreferences.getInstance();
    final accepted = prefs.getBool('accepted_legal') ?? false;
    setState(() {
      _accepted = accepted;
      _loading = false;
    });
    if (!accepted) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showConsentDialog());
    }
  }

  Future<void> _showConsentDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Accept Terms'),
          content: const Text(
            'To use this app, you must accept our Privacy Policy and Terms and Conditions.'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LegalHubScreen(),
                  ),
                );
              },
              child: const Text('View Policies'),
            ),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('accepted_legal', true);
                setState(() {
                  _accepted = true;
                });
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Accept'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!_accepted) {
      return const SizedBox.shrink();
    }
    return widget.child;
  }
} 