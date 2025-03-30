import 'package:flutter/material.dart';
import 'dart:math';

class RetirementCalculator extends StatefulWidget {
  const RetirementCalculator({super.key});

  @override
  _RetirementCalculatorState createState() => _RetirementCalculatorState();
}

class _RetirementCalculatorState extends State<RetirementCalculator> {
  final _formKey = GlobalKey<FormState>();

  int currentAge = 0;
  int retirementAge = 0;
  double currentSavings = 0;
  double monthlyContribution = 0;
  double expectedReturn = 0;
  double inflationRate = 0;

  double corpusAtRetirement = 0;
  int yearsInRetirement = 0;

  void calculateRetirement() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      int yearsToRetirement = retirementAge - currentAge;
      yearsInRetirement =
          85 - retirementAge; // Assuming life expectancy of 85 years

      // Real rate of return (adjusted for inflation)
      double realReturnRate =
          ((1 + expectedReturn / 100) / (1 + inflationRate / 100)) - 1;

      // Calculate corpus at retirement
      double futureValueOfCurrentSavings =
          currentSavings * pow(1 + expectedReturn / 100, yearsToRetirement);

      // Future value of monthly contributions
      double monthlyRate = expectedReturn / (12 * 100);
      int months = yearsToRetirement * 12;
      double futureValueOfContributions = monthlyContribution *
          ((pow(1 + monthlyRate, months) - 1) / monthlyRate) *
          (1 + monthlyRate);

      corpusAtRetirement =
          futureValueOfCurrentSavings + futureValueOfContributions;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: const Text(
                          'Retirement Calculator',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildGlassTextField(
                          label: 'Current Age',
                          onSaved: (value) => currentAge = int.parse(value!),
                        ),
                        const SizedBox(height: 12),
                        _buildGlassTextField(
                          label: 'Retirement Age',
                          onSaved: (value) => retirementAge = int.parse(value!),
                        ),
                        const SizedBox(height: 12),
                        _buildGlassTextField(
                          label: 'Current Savings',
                          onSaved: (value) =>
                              currentSavings = double.parse(value!),
                        ),
                        const SizedBox(height: 12),
                        _buildGlassTextField(
                          label: 'Monthly Contribution',
                          onSaved: (value) =>
                              monthlyContribution = double.parse(value!),
                        ),
                        const SizedBox(height: 12),
                        _buildGlassTextField(
                          label: 'Expected Annual Return (%)',
                          onSaved: (value) =>
                              expectedReturn = double.parse(value!),
                        ),
                        const SizedBox(height: 12),
                        _buildGlassTextField(
                          label: 'Inflation Rate (%)',
                          onSaved: (value) =>
                              inflationRate = double.parse(value!),
                        ),
                        const SizedBox(height: 20),

                        // Calculate Button
                        ElevatedButton(
                          onPressed: calculateRetirement,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          child: const Text(
                            'Calculate',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Result
                  if (corpusAtRetirement > 0)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: _buildResultsCard(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTextField({
    required String label,
    required Function(String?) onSaved,
  }) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }

  Widget _buildResultsCard() {
    // Calculate monthly withdrawal (4% rule)
    double annualWithdrawal = corpusAtRetirement * 0.04;
    double monthlyWithdrawal = annualWithdrawal / 12;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Retirement Corpus: ₹${corpusAtRetirement.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Estimated Monthly Income: ₹${monthlyWithdrawal.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Years in Retirement: $yearsInRetirement',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
