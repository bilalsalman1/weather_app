import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/services/services.dart';
import 'package:intl/intl.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  late WeatherData weatherInfo;
  bool isLoading = true;
  bool hasError = false;
  TextEditingController _controller = TextEditingController();

  Future<void> myWeather(String cityName) async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      WeatherData value = await WeatherServices().fetchWeatherByCity(cityName);
      setState(() {
        weatherInfo = value;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      print('Error occurred: $e');
    }
  }

  String getLocalTime(int timezoneOffset) {
    DateTime utcTime = DateTime.now().toUtc();
    DateTime localTime = utcTime.add(Duration(seconds: timezoneOffset));
    return DateFormat('hh:mm a').format(localTime);
  }

  @override
  void initState() {
    super.initState();
    myWeather('karachi');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 30, left: 20, right: 20, bottom: 100),
                child: TextField(
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  controller: _controller,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter City Name',
                    hintStyle:
                        const TextStyle(fontSize: 18, color: Colors.white),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        String cityName = _controller.text;
                        if (cityName.isNotEmpty) {
                          myWeather(cityName);
                        }
                      },
                    ),
                  ),
                ),
              ),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : hasError
                      ? Center(
                          child: Text(
                            'Failed to load weather data. Please try again.',
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        )
                      : Center(
                          child: WeatherDetail(
                            weather: weatherInfo,
                            localTime: getLocalTime(weatherInfo.timezone),
                            localDate: weatherInfo.localDate,
                            condition: weatherInfo.weather[0].main,
                          ),
                        ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherDetail extends StatelessWidget {
  final WeatherData weather;
  final String localTime;
  final String condition;
  final String localDate;

  const WeatherDetail({
    super.key,
    required this.localDate,
    required this.weather,
    required this.localTime,
    required this.condition,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ' ${weather.name}',
                  style: GoogleFonts.poppins(
                      color: const Color(0xffDDB130),
                      fontWeight: FontWeight.bold,
                      fontSize: 40),
                ),
                const SizedBox(height: 10),
                Text(
                  localDate,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(height: 25),
                Text(
                  '${weather.temperature.current.toStringAsFixed(0)}°',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 40),
                ),
                const SizedBox(height: 25),
                Text(
                  condition,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 200),
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withOpacity(0.5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WeatherInfoColumn(
                  iconPath: 'assets/humidity.png',
                  label: 'Humidity',
                  value: '${weather.humidity.toStringAsFixed(0)}%',
                ),
                _WeatherInfoColumn(
                  iconPath: 'assets/wind.png',
                  label: 'Wind',
                  value: '${weather.wind.speed} km/hr',
                ),
                _WeatherInfoColumn(
                  iconPath: 'assets/barometer.png',
                  label: 'Pressure',
                  value: '${weather.pressure.toStringAsFixed(0)} hPa',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherInfoColumn extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;

  const _WeatherInfoColumn({
    Key? key,
    required this.iconPath,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          iconPath,
          color: Colors.white,
          height: 40,
          width: 40,
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
