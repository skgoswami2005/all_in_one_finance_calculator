import 'package:flutter/material.dart';
import 'dart:math';

class InvestmentCalculator extends StatefulWidget {
  const InvestmentCalculator({super.key});

  @override
  _InvestmentCalculatorState createState() => _InvestmentCalculatorState();
}

class _InvestmentCalculatorState extends State<InvestmentCalculator> {
  final _formKey = GlobalKey<FormState>();
  double initialInvestment = 0;
  double monthlyContribution = 0;
  double interestRate = 0;
  int timePeriod = 0;
  double futureValue = 0;
  double totalContributions = 0;
  double totalInterestEarned = 0;

  // Investment calculation types
  final List<String> calculationTypes = ['Lump Sum', 'SIP (Monthly)'];
  String selectedCalculationType = 'Lump Sum';

  void calculateInvestment() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (selectedCalculationType == 'Lump Sum') {
        // Lump sum calculation (one-time investment)
        futureValue =
            initialInvestment * pow((1 + interestRate / 100), timePeriod);
        totalContributions = initialInvestment;
      } else {
        // SIP calculation (regular monthly investment)
        double monthlyRate = interestRate / 1200; // monthly rate in decimal
        int months = timePeriod * 12;

        // Formula for future value of a series of regular payments
        futureValue = monthlyContribution *
            ((pow(1 + monthlyRate, months) - 1) / monthlyRate) *
            (1 + monthlyRate);
        totalContributions = monthlyContribution * months;
      }

      totalInterestEarned = futureValue - totalContributions;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove the body container to apply decoration to the full scaffold
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
                  // Header with flexible text
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
                      // Use Flexible or Expanded to prevent overflow
                      Flexible(
                        child: const Text(
                          'Investment Calculator',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow:
                              TextOverflow.ellipsis, // Handle text overflow
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Calculation Type Selector
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCalculationType,
                        isExpanded: true,
                        dropdownColor: const Color(0xFF6A11CB),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        iconEnabledColor: Colors.white,
                        items: calculationTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCalculationType = newValue!;
                            // Reset results when changing calculation type
                            futureValue = 0;
                            totalContributions = 0;
                            totalInterestEarned = 0;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (selectedCalculationType == 'Lump Sum')
                          _buildGlassTextField(
                            label: 'Initial Investment',
                            onSaved: (value) =>
                                initialInvestment = double.parse(value!),
                          )
                        else
                          _buildGlassTextField(
                            label: 'Monthly Contribution',
                            onSaved: (value) =>
                                monthlyContribution = double.parse(value!),
                          ),
                        const SizedBox(height: 12),
                        _buildGlassTextField(
                          label: 'Interest Rate (%)',
                          onSaved: (value) =>
                              interestRate = double.parse(value!),
                        ),
                        const SizedBox(height: 12),
                        _buildGlassTextField(
                          label: 'Time Period (in years)',
                          onSaved: (value) => timePeriod = int.parse(value!),
                        ),
                        const SizedBox(height: 20),

                        // Calculate Button
                        ElevatedButton(
                          onPressed: calculateInvestment,
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
                  if (futureValue > 0)
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
            'Future Value: ₹${futureValue.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Total Contribution: ₹${totalContributions.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          Text(
            'Total Interest Earned: ₹${totalInterestEarned.toStringAsFixed(2)}',
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
