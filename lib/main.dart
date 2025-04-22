import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/emi_calculator.dart';
import 'screens/loan_calculator.dart';
import 'screens/interest_calculator.dart';
import 'screens/investment_calculator.dart';
import 'screens/tax_calculator.dart';
import 'screens/gst_calculator.dart';
import 'screens/retirement_calculator.dart';
import 'screens/currency_converter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(FinanceCalculatorApp());
}

class FinanceCalculatorApp extends StatelessWidget {
  const FinanceCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          }
          return AuthWrapper();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool showLogin = true;

  void toggleView() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return LoginScreen(onSignupTap: toggleView);
    } else {
      return SignupScreen(onLoginTap: toggleView);
    }
  }
}

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> calculators = [
    {
      'title': 'EMI Calculator',
      'screen': EmiCalculator(),
      'icon': Icons.calculate
    },
    {
      'title': 'Loan Calculator',
      'screen': LoanCalculator(),
      'icon': Icons.account_balance
    },
    {
      'title': 'Interest Calculator',
      'screen': InterestCalculator(),
      'icon': Icons.percent
    },
    {
      'title': 'Investment Calculator',
      'screen': InvestmentCalculator(),
      'icon': Icons.trending_up
    },
    {
      'title': 'Tax Calculator',
      'screen': TaxCalculator(),
      'icon': Icons.receipt_long
    },
    {
      'title': 'GST Calculator',
      'screen': GstCalculator(),
      'icon': Icons.receipt
    },
    {
      'title': 'Retirement Calculator',
      'screen': RetirementCalculator(),
      'icon': Icons.house
    },
    {
      'title': 'Currency Converter',
      'screen': CurrencyConverter(),
      'icon': Icons.currency_exchange
    },
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with logout button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Finance Calculator',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'All your financial needs in one place',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.signOut();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error signing out: $e')),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      tooltip: 'Logout',
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1,
                    ),
                    itemCount: calculators.length,
                    itemBuilder: (context, index) {
                      return _buildCalculatorCard(
                        context,
                        calculators[index]['title'],
                        calculators[index]['icon'],
                        calculators[index]['screen'],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalculatorCard(
      BuildContext context, String title, IconData icon, Widget screen) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
