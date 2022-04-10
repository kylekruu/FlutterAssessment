import 'package:flutter/material.dart';
import 'package:flutter_weather/Screens/homeScreen.dart';
import 'package:flutter_weather/models/weather.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dailyWeather.dart';
import 'package:provider/provider.dart';

import '../viewmodel/WeatherViewModel.dart';

class Location extends StatefulWidget {
  static const routeName = '/locationScreen';
  Location({Key key}) : super(key: key);



  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<Location> {
   List<Weather> data;
   @override
   void initState() {
     super.initState();
     getWeatherPrefs();
     data = [];
   }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return
              GestureDetector(
              onTap: () {
                Provider.of<WeatherViewModel>(context, listen: false).searchWeatherData(location :data[index].cityName.toString());
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen(isNew: false,))
                );
              },
              child: Dismissible(
              key: Key(data[index].cityName),
              background: Container(
                alignment: AlignmentDirectional.centerEnd,
                color: Colors.red,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) {
                setState(() {
                  data.removeWhere((element) => element.cityName == data[index].cityName);
                  updateWeatherList();
                });
              },
              direction: DismissDirection.endToStart,
              child: Card(
                elevation: 5,
                child: Container(
                  height: 50.0,
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 20,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${data[index].cityName}, ${data[index].country}",

                              ),

                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
          },
        ));
  }

   void updateWeatherList() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();

     final String encodedData = Weather.encode(data);

     setState(() {
       prefs.setString('weatherData', encodedData);
     });

   }

   void getWeatherPrefs() async {
     final SharedPreferences prefs = await SharedPreferences.getInstance();

     final String weatherString = prefs.getString('weatherData');

     final List<Weather> weather = Weather.decode(weatherString);

     setState(() {
       data.addAll(weather);
     });
   }

}