import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_model.dart';

class WeatherServices {
  final String apiKey = "509079b22fae7e954dff8403ef5eba0e";
  Future<WeatherData> fetchWeatherByCity(String cityName) async {
    final response = await http.get(
      Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey"),
    );

    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return WeatherData.fromJson(json);
      } else {
        throw Exception(
            'Failed to load weather data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      rethrow;
    }
  }
}
