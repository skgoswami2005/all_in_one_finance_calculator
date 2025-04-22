import 'package:flutter/material.dart';

class TaxCalculator extends StatefulWidget {
  const TaxCalculator({super.key});

  @override
  _TaxCalculatorState createState() => _TaxCalculatorState();
}

class _TaxCalculatorState extends State<TaxCalculator> {
  final _formKey = GlobalKey<FormState>();
  double income = 0;
  double deductions = 0;
  String taxRegime = 'New Regime';
  double taxAmount = 0;
  double effectiveTaxRate = 0;

  final List<String> taxRegimes = ['New Regime', 'Old Regime'];

  void calculateTax() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      double taxableIncome = income - deductions;
      if (taxableIncome <= 0) {
        taxableIncome = 0;
      }

      double tax = 0;

      if (taxRegime == 'New Regime') {
        // New regime tax calculation (Example for India 2023-24)
        if (taxableIncome <= 300000) {
          tax = 0;
        } else if (taxableIncome <= 600000) {
          tax = (taxableIncome - 300000) * 0.05;
        } else if (taxableIncome <= 900000) {
          tax = 15000 + (taxableIncome - 600000) * 0.10;
        } else if (taxableIncome <= 1200000) {
          tax = 45000 + (taxableIncome - 900000) * 0.15;
        } else if (taxableIncome <= 1500000) {
          tax = 90000 + (taxableIncome - 1200000) * 0.20;
        } else {
          tax = 150000 + (taxableIncome - 1500000) * 0.30;
        }
      } else {
        // Old regime tax calculation (Example for India 2023-24)
        if (taxableIncome <= 250000) {
          tax = 0;
        } else if (taxableIncome <= 500000) {
          tax = (taxableIncome - 250000) * 0.05;
        } else if (taxableIncome <= 1000000) {
          tax = 12500 + (taxableIncome - 500000) * 0.20;
        } else {
          tax = 112500 + (taxableIncome - 1000000) * 0.30;
        }
      }

      // Add 4% cess
      tax = tax * 1.04;

      taxAmount = tax;
      effectiveTaxRate = (income > 0) ? (tax / income) * 100 : 0;

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
                          'Income Tax Calculator',
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

                  // Regime Selector
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: taxRegime,
                        isExpanded: true,
                        dropdownColor: const Color(0xFF6A11CB),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        iconEnabledColor: Colors.white,
                        items: taxRegimes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            taxRegime = newValue!;
                            taxAmount = 0;
                            effectiveTaxRate = 0;
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
                        _buildGlassTextField(
                          label: 'Annual Income',
                          onSaved: (value) => income = double.parse(value!),
                        ),
                        const SizedBox(height: 12),
                        _buildGlassTextField(
                          label: 'Total Deductions',
                          onSaved: (value) => deductions = double.parse(value!),
                        ),
                        const SizedBox(height: 20),

                        // Calculate Button
                        ElevatedButton(
                          onPressed: calculateTax,
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
                  if (taxAmount > 0)
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Tax Amount: ₹${taxAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Effective Tax Rate: ${effectiveTaxRate.toStringAsFixed(2)}%',
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
