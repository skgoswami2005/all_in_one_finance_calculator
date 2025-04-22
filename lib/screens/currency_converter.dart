import 'package:flutter/material.dart';
import '../services/exchange_rate_service.dart';

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final _formKey = GlobalKey<FormState>();
  double amount = 0;
  String fromCurrency = 'INR';
  String toCurrency = 'USD';
  double convertedAmount = 0;

  Map<String, double> currentRates = {};
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchExchangeRates();
  }

  Future<void> fetchExchangeRates() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final rates = await ExchangeRateService.getExchangeRates(fromCurrency);
      setState(() {
        currentRates = rates;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void convertCurrency() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (currentRates.containsKey(toCurrency)) {
        double rate = currentRates[toCurrency]!;
        convertedAmount = amount * rate;
        setState(() {});
      }
    }
  }

  void swapCurrencies() {
    setState(() {
      var temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;

      fetchExchangeRates();

      if (amount > 0) {
        convertCurrency();
      }
    });
  }

  void onCurrencyChanged(String? newValue, bool isFrom) {
    setState(() {
      if (isFrom) {
        fromCurrency = newValue!;
        fetchExchangeRates();
      } else {
        toCurrency = newValue!;
        if (amount > 0) convertCurrency();
      }
    });
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
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: $error',
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: fetchExchangeRates,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : SafeArea(
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
                                    'Currency Converter',
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
                            const SizedBox(height: 30),

                            // Form
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  _buildGlassTextField(
                                    label: 'Amount',
                                    onSaved: (value) =>
                                        amount = double.parse(value!),
                                  ),
                                  const SizedBox(height: 20),

                                  // Currency selection
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildCurrencyDropdown(
                                          label: 'From',
                                          value: fromCurrency,
                                          onChanged: (value) =>
                                              onCurrencyChanged(value, true),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: swapCurrencies,
                                        icon: const Icon(
                                          Icons.swap_horiz,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      ),
                                      Expanded(
                                        child: _buildCurrencyDropdown(
                                          label: 'To',
                                          value: toCurrency,
                                          onChanged: (value) =>
                                              onCurrencyChanged(value, false),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Calculate Button
                                  ElevatedButton(
                                    onPressed: convertCurrency,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.white.withOpacity(0.2),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 3,
                                    ),
                                    child: const Text(
                                      'Convert',
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

                            const SizedBox(height: 40),

                            // Result
                            if (convertedAmount > 0)
                              Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
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

  Widget _buildCurrencyDropdown({
    required String label,
    required String value,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF6A11CB),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              iconEnabledColor: Colors.white,
              items: ['INR', 'USD', 'EUR', 'GBP', 'AUD', 'CAD', 'JPY']
                  .map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCard() {
    Map<String, String> currencySymbols = {
      'INR': '₹',
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'AUD': 'A\$',
      'CAD': 'C\$',
      'JPY': '¥',
    };

    String fromSymbol = currencySymbols[fromCurrency] ?? '';
    String toSymbol = currencySymbols[toCurrency] ?? '';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '$fromSymbol${amount.toStringAsFixed(2)} $fromCurrency =',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$toSymbol${convertedAmount.toStringAsFixed(2)} $toCurrency',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Exchange Rate: 1 $fromCurrency = ${currentRates[toCurrency]?.toStringAsFixed(6)} $toCurrency',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          if (currentRates.isNotEmpty)
            Text(
              'Exchange Rate: 1 $fromCurrency = ${currentRates[toCurrency]?.toStringAsFixed(4)} $toCurrency',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
