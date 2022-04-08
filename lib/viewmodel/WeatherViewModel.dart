import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../themes/DarkThemePreference.dart';
import '../models/weather.dart';
import '../models/dailyWeather.dart';

enum ThemeType { DARK, LIGHT }
class WeatherViewModel with ChangeNotifier {
  String apiKey = '99281cbd7c0f1372ae8afa3aa8b10fe0';
  Weather weather = Weather();
  DailyWeather currentWeather = DailyWeather();
  List<DailyWeather> hourlyWeather = [];
  List<DailyWeather> hourly24Weather = [];
  List<DailyWeather> fiveDayWeather = [];
  List<DailyWeather> sevenDayWeather = [];
  List<Weather> sevenDayWeather1 = [];
  List<Weather> savedWeather = [];
  bool loading;
  bool isRequestError = false;
  bool isLocationError = false;
  bool _isDarkTheme = false;
  ThemeMode _mode;
  ThemeMode get mode => _mode;
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;
  bool isFahrenheit = false;
  int tempSwitch = 0;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }

  setWeather(Weather weather) {
    this.weather = weather;
    notifyListeners();
  }

  getWeatherData() async {
    loading = true;
    isRequestError = false;
    isLocationError = false;
    await Location().requestService().then((value) async {
      if (value) {
        final locData = await Location().getLocation();
        var latitude = locData.latitude;
        var longitude = locData.longitude;
        Uri url = Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey');
        Uri dailyUrl = Uri.parse(
            'https://api.openweathermap.org/data/2.5/onecall?lat=$latitude&lon=$longitude&units=metric&exclude=minutely,current&appid=$apiKey');
        try {
          final response = await http.get(url);
          final extractedData =
              json.decode(response.body) as Map<String, dynamic>;
          weather = Weather.fromJson(extractedData);
        } catch (error) {
          loading = false;
          this.isRequestError = true;
          notifyListeners();
        }
        try {
          final response = await http.get(dailyUrl);
          final dailyData = json.decode(response.body) as Map<String, dynamic>;
          currentWeather = DailyWeather.fromJson(dailyData);
          var tempHourly = [];
          var temp24Hour = [];
          var tempSevenDay = [];
          List items = dailyData['daily'];
          List itemsHourly = dailyData['hourly'];
          tempHourly = itemsHourly
              .map((item) => DailyWeather.fromHourlyJson(item))
              .toList()
              .skip(1)
              .take(3)
              .toList();
          temp24Hour = itemsHourly
              .map((item) => DailyWeather.fromHourlyJson(item))
              .toList()
              .skip(1)
              .take(24)
              .toList();
          tempSevenDay = items
              .map((item) => DailyWeather.fromDailyJson(item))
              .toList()
              .skip(1)
              .take(7)
              .toList();
          hourlyWeather = tempHourly;
          hourly24Weather = temp24Hour;
          sevenDayWeather = tempSevenDay;
          loading = false;
          notifyListeners();
        } catch (error) {
          loading = false;
          this.isRequestError = true;
          notifyListeners();
          throw error;
        }
      } else {
        loading = false;
        isLocationError = true;
        notifyListeners();
      }
    });
  }

  searchWeatherData({String location}) async {
    loading = true;
    isRequestError = false;
    isLocationError = false;
    Uri url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&units=metric&appid=$apiKey');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      weather = Weather.fromJson(extractedData);
    } catch (error) {
      loading = false;
      this.isRequestError = true;
      notifyListeners();
      throw error;
    }
    var latitude = weather.lat;
    var longitude = weather.long;
    print(latitude);
    print(longitude);
    Uri dailyUrl = Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=$latitude&lon=$longitude&units=metric&exclude=minutely,current&appid=$apiKey');
    try {
      final response = await http.get(dailyUrl);
      final dailyData = json.decode(response.body) as Map<String, dynamic>;
      print(dailyUrl);
      currentWeather = DailyWeather.fromJson(dailyData);
      var tempHourly = [];
      var temp24Hour = [];
      var tempSevenDay = [];
      List items = dailyData['daily'];
      List itemsHourly = dailyData['hourly'];
      tempHourly = itemsHourly
          .map((item) => DailyWeather.fromHourlyJson(item))
          .toList()
          .skip(1)
          .take(3)
          .toList();
      temp24Hour = itemsHourly
          .map((item) => DailyWeather.fromHourlyJson(item))
          .toList()
          .skip(1)
          .take(24)
          .toList();
      tempSevenDay = items
          .map((item) => DailyWeather.fromDailyJson(item))
          .toList()
          .skip(1)
          .take(7)
          .toList();
      hourlyWeather = tempHourly;
      hourly24Weather = temp24Hour;
      sevenDayWeather = tempSevenDay;
      loading = false;
      notifyListeners();
    } catch (error) {
      loading = false;
      this.isRequestError = true;
      notifyListeners();
      throw error;
    }
  }

  double tempTransform(double temp)  {
    double finalTemp;

     if (isFahrenheit == true || tempSwitch == 1)
      finalTemp = (temp * 9 / 5) + 32;
     else
       finalTemp = temp;

    return finalTemp.roundToDouble();

  }

  void switchTempFormat(int val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Fetch and decode data
    bool isFahrenheitPref = prefs.getBool('isFahrenheit');

    if (isFahrenheitPref == null || isFahrenheitPref == true) {
      prefs.setBool('isFahrenheit', false);
    } else {
      prefs.setBool('isFahrenheit', true);
    }
    tempSwitch = val;
    isFahrenheit = isFahrenheitPref;
    notifyListeners();
  }

}
