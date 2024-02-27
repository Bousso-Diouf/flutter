import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  final String cityName;
  final double temperature;
  final String cloudCoverage;

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.cloudCoverage,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
  return WeatherData(
    cityName: json['name'],
    temperature: (json['main']['temp'] - 273.15), // Conversion en Celsius
    cloudCoverage: json['weather'][0]['description'], 
  );
}

}


Future<WeatherData> fetchWeatherData(String city) async {
  final apiKey = 'a2b9e9b785ea109f21a20bf9e690d67d';
  final apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&lang=fr';


  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final weatherData = WeatherData.fromJson(jsonData);
    
    return weatherData; // Retourner l'instance de WeatherData
  } else {
    throw Exception('Failed to fetch weather data for $city');
  }
}