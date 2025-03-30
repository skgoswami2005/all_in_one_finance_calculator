import 'package:flutter/material.dart';
import 'dart:math';

class LoanCalculator extends StatefulWidget {
  const LoanCalculator({super.key});

  @override
  _LoanCalculatorState createState() => _LoanCalculatorState();
}

class _LoanCalculatorState extends State<LoanCalculator> {
  final _formKey = GlobalKey<FormState>();
  double emi = 0;
  double interestRate = 0;
  int tenure = 0;
  double loanAmount = 0;

  void calculateLoanAmount() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      double monthlyInterestRate = interestRate / (12 * 100);
      int numberOfMonths = tenure * 12;

      loanAmount = (emi * (pow(1 + monthlyInterestRate, numberOfMonths) - 1)) /
          (monthlyInterestRate * pow(1 + monthlyInterestRate, numberOfMonths));

      setState(() {});
    }
  }

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
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                    const Text(
                      'Loan Calculator',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                        label: 'EMI Amount',
                        onSaved: (value) => emi = double.parse(value!),
                      ),
                      const SizedBox(height: 12),
                      _buildGlassTextField(
                        label: 'Interest Rate (%)',
                        onSaved: (value) => interestRate = double.parse(value!),
                      ),
                      const SizedBox(height: 12),
                      _buildGlassTextField(
                        label: 'Tenure (in years)',
                        onSaved: (value) => tenure = int.parse(value!),
                      ),
                      const SizedBox(height: 20),

                      // Calculate Button
                      ElevatedButton(
                        onPressed: calculateLoanAmount,
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
                if (loanAmount > 0)
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
    );
  }

  Widget _buildGlassTextField(
      {required String label, required Function(String?) onSaved}) {
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Loan Amount: ₹${loanAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
