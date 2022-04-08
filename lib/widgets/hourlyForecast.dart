import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helper/utils.dart';
import '../Screens/hourlyWeatherScreen.dart';
import '../models/dailyWeather.dart';

class HourlyForecast extends StatelessWidget {
  final wData;
  final List<DailyWeather> dWeather;

  HourlyForecast({this.wData, this.dWeather});

  Widget hourlyWidget(dynamic weather, BuildContext context) {
    final currentTime = weather.date;
    final dayOfWeek = DateFormat('EEE').format(weather.date);

    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(6, 8),
          ),
        ],
      ),
      height: 150,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  dayOfWeek,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${weather.condition}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: MapString.mapStringToIcon(
                      '${weather.condition}', context, 40),
                ),
                Container(
                  width: 80,
                  child: Text(
                    "${weather.dailyTemp.toStringAsFixed(1)}°C",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: dWeather
                  .map((item) => hourlyWidget(item, context))
                  .toList()),
          ),
        ],
      ),
    );
  }
}
