import 'package:intl/intl.dart';

class WeatherData {
  final String name;
  final Temperature temperature;
  final int humidity;
  final Wind wind;
  final double maxTemperature;
  final double minTemperature;
  final int pressure;
  final int seaLevel;
  final List<WeatherInfo> weather;
  final int timezone;
  late final String localDate;

  WeatherData({
    required this.name,
    required this.temperature,
    required this.humidity,
    required this.wind,
    required this.maxTemperature,
    required this.minTemperature,
    required this.pressure,
    required this.seaLevel,
    required this.weather,
    required this.timezone,
  }) {
    localDate = getLocalDate(timezone);
  }

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      name: json['name'],
      temperature: Temperature.fromJson(json['main']['temp']),
      humidity: json['main']['humidity'],
      wind: Wind.fromJson(json['wind']),
      maxTemperature: (json['main']['temp_max'] - 273.15),
      minTemperature: (json['main']['temp_min'] - 273.15),
      pressure: json['main']['pressure'],
      seaLevel: json['main']['sea_level'] ?? 0,
      weather: List<WeatherInfo>.from(
        json['weather'].map(
          (weather) => WeatherInfo.fromJson(weather),
        ),
      ),
      timezone: json['timezone'],
    );
  }

  String getLocalDate(int timezoneOffset) {
    DateTime utcTime = DateTime.now().toUtc();
    DateTime localTime = utcTime.add(Duration(seconds: timezoneOffset));
    return DateFormat('EEEE,MMMM dd').format(localTime);
  }
}

class WeatherInfo {
  final String main;

  WeatherInfo({
    required this.main,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      main: json['main'],
    );
  }

  get icon => null;
}

class Temperature {
  final double current;

  Temperature({required this.current});

  factory Temperature.fromJson(dynamic json) {
    return Temperature(
      current: (json - 273.15),
    );
  }
}

class Wind {
  final double speed;

  Wind({required this.speed});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(speed: json['speed']);
  }
}
