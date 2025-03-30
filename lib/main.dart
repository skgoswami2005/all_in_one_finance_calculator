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

void main() {
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
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
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
                const Text(
                  'Finance Calculator',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'All your financial needs in one place',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
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
