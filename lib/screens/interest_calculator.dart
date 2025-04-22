import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

class InterestCalculator extends StatefulWidget {
  const InterestCalculator({super.key});

  @override
  _InterestCalculatorState createState() => _InterestCalculatorState();
}

class _InterestCalculatorState extends State<InterestCalculator> {
  final _formKey = GlobalKey<FormState>();
  double principal = 0;
  double rate = 0;
  int time = 0;
  double simpleInterest = 0;
  double compoundInterest = 0;

  void calculateInterest() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Simple Interest
      simpleInterest = (principal * rate * time) / 100;

      // Compound Interest
      compoundInterest = principal * pow((1 + rate / 100), time) - principal;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
          child: SingleChildScrollView(
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
                        'Interest Calculator',
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
                          label: 'Principal Amount',
                          onSaved: (value) => principal = double.parse(value!),
                        ),
                        const SizedBox(height: 12),
                        _buildGlassTextField(
                          label: 'Rate of Interest (%)',
                          onSaved: (value) => rate = double.parse(value!),
                        ),
                        const SizedBox(height: 12),
                        _buildGlassTextField(
                          label: 'Time (in years)',
                          onSaved: (value) => time = int.parse(value!),
                        ),
                        const SizedBox(height: 20),

                        // Calculate Button
                        ElevatedButton(
                          onPressed: calculateInterest,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 14),
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
                  if (simpleInterest > 0 || compoundInterest > 0)
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
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${simpleInterest.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Text(
                '₹${compoundInterest.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        String text = '';
                        if (value == 0) text = 'Simple';
                        if (value == 1) text = 'Compound';
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            text,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: simpleInterest,
                        color: Colors.blue.shade300,
                        width: 20,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: compoundInterest,
                        color: Colors.purple.shade300,
                        width: 20,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
