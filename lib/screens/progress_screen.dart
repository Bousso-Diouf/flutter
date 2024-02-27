import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meteoapp/screens/citydetails.dart';
import 'weather_api.dart';  // Importez le fichier de la nouvelle page

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _secondsElapsed;
  bool _isLoading = true;
  Set<String> _processedCities = Set<String>(); 
  Map<String, WeatherData> _weatherDataMap = {}; // Stockage des données météorologiques pour chaque ville

  List<String> messages = [
    "Nous téléchargeons les données...",
    "C'est presque fini, plus que quelques secondes avant d'avoir le résultat.",
    "En attente des données météorologiques..."
  ];
  int currentMessageIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60),
    )..forward();

    _controller.addListener(() {
      setState(() {
        _secondsElapsed = (_controller.value * 60).round();
        _handleWeatherAPICalls();
      });
    });

    _secondsElapsed = 0;

    Timer.periodic(Duration(seconds: 6), (timer) {
      setState(() {
        currentMessageIndex = (currentMessageIndex + 1) % messages.length;
      });
    });
  }

  void _handleWeatherAPICalls() {
    if (_secondsElapsed % 10 == 0) {
      String city = _getCityForSeconds(_secondsElapsed);
      if (!_processedCities.contains(city)) {
        fetchWeatherData(city).then((weatherData) {
          setState(() {
            _processedCities.add(city);
            _weatherDataMap[city] = weatherData; // Stocker les données météorologiques
            if (_processedCities.length == 5) {
              _isLoading = false; // Mettre à jour _isLoading une fois que toutes les villes sont chargées
            }
          });
        });
      }
    }
  }

  String _getCityForSeconds(int seconds) {
    switch (seconds) {
      case 10:
        return 'Dakar';
      case 20:
        return 'Mbour';
      case 30:
        return 'Kaolack';
      case 40:
        return 'Saint-louis';
      case 50:
        return 'Fatick';
      default:
        return '';
    }
  }

  double getTemperature(String city) {
    WeatherData? weatherData = _weatherDataMap[city];
    if (weatherData != null) {
      return weatherData.temperature;
    } else {
      return 0.0; // Valeur par défaut ou indication que la température n'est pas disponible
    }
  }

  String getCloudCoverage(String city) {
    WeatherData? weatherData = _weatherDataMap[city];
    if (weatherData != null) {
      return weatherData.cloudCoverage;
    } else {
      return 'N/A'; // Valeur par défaut ou indication que la couverture nuageuse n'est pas disponible
    }
  }

  @override
  Widget build(BuildContext context) {
    double progressPercentage = (_controller.value * 100).roundToDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text('Écran de progression'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: _processedCities.map((city) {
                return ListTile(
                  title: Text(city),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CityDetailScreen(city: city,temperature: getTemperature(city),
      cloudCoverage: getCloudCoverage(city),),
                      ),
                    );
                  },
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Température: ${getTemperature(city)}°C'),
                      Text('Couverture nuageuse: ${getCloudCoverage(city)}'),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                (_isLoading)
                  ? Column(
                      children: [
                        LinearProgressIndicator(
                          value: _controller.value,
                          minHeight: 20,
                          backgroundColor: Colors.grey,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        SizedBox(height: 10), // Ajout d'un espace entre la jauge et le texte d'attente
                        Text(messages[currentMessageIndex]),
                      ],
                    )
                  : Container(), // Ne rien afficher lorsque _isLoading est false
                if (!_isLoading && _processedCities.length == 5) // Afficher le bouton seulement si _isLoading est false et toutes les villes sont chargées
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        _processedCities.clear();
                        _weatherDataMap.clear(); // Effacer les données météorologiques stockées
                        _controller.reset();
                        _controller.forward();
                      });
                    },
                    child: Text('Recommencer'),
                  ),
                SizedBox(width: 10),
                Text('$progressPercentage%'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
