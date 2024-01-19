import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DataService {
  Future<WeatherResponse> getWeather(String city, BuildContext context) async {
    final queryParameters = {
      'q': city,
      'appid': 'e1e449e9d0b314c7bac1681d070366a5',
      'units': 'metric',
      'lang': AppLocalizations.of(context)!.language,
    };

    final uri = Uri.https('api.openweathermap.org', '/data/2.5/weather', queryParameters);
    final response = await http.get(uri);
    final json = jsonDecode(response.body);

    return WeatherResponse.fromJson(json);
  }
}