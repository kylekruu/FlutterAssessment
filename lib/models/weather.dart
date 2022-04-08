import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Weather {

  var temp;
  var tempMax;
  var tempMin;
  var lat;
  var long;
  var feelsLike;
  var pressure;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  var cityName;
  var country;
  var dt;
  var sunrise;
  var sunset;

  Weather({
    this.temp,
    this.tempMax,
    this.tempMin,
    this.lat,
    this.long,
    this.feelsLike,
    this.pressure,
    this.description,
    this.currently,
    this.humidity,
    this.windSpeed,
    this.cityName,
    this.country,
    this.dt,
    this.sunrise,
    this.sunset,
  });

  factory Weather.fromJson(dynamic json) {
    return Weather(
      temp: json['main']['temp'],
      tempMax: json['main']['temp_max'],
      tempMin: json['main']['temp_min'],
      lat: json['coord']['lat'],
      long: json['coord']['lon'],
      feelsLike: json['main']['feels_like'],
      pressure: json['main']['pressure'],
      description: json['weather'][0]['description'],
      currently: json['weather'][0]['main'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'],
      cityName: json['name'],
      country: json['sys']['country'],
      dt: json['dt'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
    );
  }

  factory Weather.fromJson1(Map<String, dynamic> json) {
    return Weather(
      temp: json['temp'],
      tempMax: json['temp_max'],
      tempMin: json['temp_min'],
      lat: json['lat'],
      long: json['lon'],
      feelsLike: json['feels_like'],
      pressure: json['pressure'],
      description: json['description'],
      currently: json['main'],
      humidity: json['humidity'],
      windSpeed: json['speed'],
      cityName: json['cityName'],
      country: json['country'],
      dt: json['dt'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }

  static Weather fromDailyJson(dynamic json) {
    return Weather(
      temp: json['main']['temp'],
      tempMax: json['main']['temp_max'],
      tempMin: json['main']['temp_min'],
      lat: json['coord']['lat'],
      long: json['coord']['lon'],
      feelsLike: json['main']['feels_like'],
      pressure: json['main']['pressure'],
      description: json['weather'][0]['description'],
      currently: json['weather'][0]['main'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'],
      cityName: json['name'],
      country: json['sys']['country'],
      dt: json['dt'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
    );
  }

  Weather.fromMap(Map<String, dynamic> json) :
        temp = json['main']['temp'],
        tempMax= json['main']['temp_max'],
        tempMin= json['main']['temp_min'],
        lat= json['coord']['lat'],
        long=json['coord']['lon'],
        feelsLike= json['main']['feels_like'],
        pressure= json['main']['pressure'],
        description= json['weather'][0]['description'],
        currently= json['weather'][0]['main'],
        humidity= json['main']['humidity'],
        windSpeed= json['wind']['speed'],
        cityName= json['name'],
        country= json['sys']['country'],
        dt = json['dt'],
        sunrise = json['sys']['sunrise'],
        sunset = json['sys']['sunset'];

  Map<String, dynamic> toMap() {
    return {
      'temp': temp,
      'tempMax': tempMax,
      'tempMin': tempMin,
      'lat': lat,
      'long': long,
      'feelsLike': feelsLike,
      'pressure': pressure,
      'description': description,
      'currently': currently,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'cityName': cityName,
      'country': country,
      'dt': dt,
      'sunrise': sunrise,
      'sunset': sunset,
    };
  }

  static Map<String, dynamic> toMapPrefs(Weather weather) => {
      'temp': weather.temp,
      'tempMax': weather.tempMax,
      'tempMin': weather.tempMin,
      'lat': weather.lat,
      'long': weather.long,
      'feelsLike': weather.feelsLike,
      'pressure': weather.pressure,
      'description': weather.description,
      'currently': weather.currently,
      'humidity': weather.humidity,
      'windSpeed': weather.windSpeed,
      'cityName': weather.cityName,
      'country': weather.country,
      'dt': weather.dt,
      'sunrise': weather.sunrise,
      'sunset': weather.sunset,
  };


  static String encode(List<Weather> weather) => json.encode(
    weather
        .map<Map<String, dynamic>>((weather) => Weather.toMapPrefs(weather))
        .toList(),
  );

  static List<Weather> decode(String weather) =>
      (json.decode(weather) as List<dynamic>)
          .map<Weather>((item) => Weather.fromJson1(item))
          .toList();

}
