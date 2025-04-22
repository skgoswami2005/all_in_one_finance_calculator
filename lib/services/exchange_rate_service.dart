import 'package:http/http.dart' as http;
import 'dart:convert';

class ExchangeRateService {
  static const String apiKey =
      '164cc2529f661301ee62f3fe'; // Replace with your actual API key
  static const String baseUrl = 'https://v6.exchangerate-api.com/v6';

  static Future<Map<String, double>> getExchangeRates(
      String baseCurrency) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$apiKey/latest/$baseCurrency'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['result'] == 'success') {
          // Convert all values to double, whether they're int or double
          Map<String, double> rates = Map<String, double>.from(
            data['conversion_rates'].map((key, value) => MapEntry(
                  key,
                  value is int ? value.toDouble() : value as double,
                )),
          );
          return rates;
        }
      }
      throw Exception('Failed to load exchange rates');
    } catch (e) {
      throw Exception('Error fetching exchange rates: $e');
    }
  }
}
