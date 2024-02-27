import 'package:flutter/material.dart';

class CityDetailScreen extends StatelessWidget {
  final String city;
  final double temperature;
  final String cloudCoverage;

  CityDetailScreen({
    required this.city,
    required this.temperature,
    required this.cloudCoverage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de $city'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ville: $city'),
            Text('Température: $temperature°C'),
            Text('Couverture nuageuse: $cloudCoverage'),
          ],
        ),
      ),
    );
  }
}
