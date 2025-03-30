import 'package:flutter/material.dart';

class GstCalculator extends StatefulWidget {
  const GstCalculator({super.key});

  @override
  _GstCalculatorState createState() => _GstCalculatorState();
}

class _GstCalculatorState extends State<GstCalculator> {
  final _formKey = GlobalKey<FormState>();
  double amount = 0;
  double gstRate = 18; // Default GST rate
  bool isGstInclusive = false;
  double gstAmount = 0;
  double netAmount = 0;
  double totalAmount = 0;

  final List<double> gstRates = [0, 3, 5, 12, 18, 28];

  void calculateGST() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (isGstInclusive) {
        // Calculate GST from inclusive amount
        gstAmount = amount - (amount / (1 + (gstRate / 100)));
        netAmount = amount - gstAmount;
        totalAmount = amount;
      } else {
        // Calculate GST and add to amount
        gstAmount = amount * (gstRate / 100);
        netAmount = amount;
        totalAmount = amount + gstAmount;
      }

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
                          'GST Calculator',
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

                  // GST Rate Selector
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<double>(
                        value: gstRate,
                        isExpanded: true,
                        dropdownColor: const Color(0xFF6A11CB),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        iconEnabledColor: Colors.white,
                        items: gstRates.map((double rate) {
                          return DropdownMenuItem<double>(
                            value: rate,
                            child: Text('$rate%'),
                          );
                        }).toList(),
                        onChanged: (double? newValue) {
                          setState(() {
                            gstRate = newValue!;
                            gstAmount = 0;
                            netAmount = 0;
                            totalAmount = 0;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // GST Inclusive/Exclusive Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isGstInclusive ? 'GST Inclusive' : 'GST Exclusive',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Switch(
                          value: isGstInclusive,
                          onChanged: (value) {
                            setState(() {
                              isGstInclusive = value;
                              // Reset values when switching modes
                              gstAmount = 0;
                              netAmount = 0;
                              totalAmount = 0;
                            });
                          },
                          activeColor: Colors.white,
                          activeTrackColor: Colors.white.withOpacity(0.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildGlassTextField(
                          label: isGstInclusive
                              ? 'Amount (GST Inclusive)'
                              : 'Amount (GST Exclusive)',
                          onSaved: (value) => amount = double.parse(value!),
                        ),
                        const SizedBox(height: 20),

                        // Calculate Button
                        ElevatedButton(
                          onPressed: calculateGST,
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
                  if (gstAmount > 0)
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
            'Net Amount: ₹${netAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'GST Amount (${gstRate.toStringAsFixed(0)}%): ₹${gstAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Total Amount: ₹${totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
