import 'package:flutter/material.dart';
import 'package:flutter_weather/models/weather.dart';
import 'package:flutter_weather/viewmodel/WeatherViewModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homeScreen.dart';
import 'locationScreen.dart';
import 'settingScreen.dart';

class Navigation extends StatefulWidget {
  @override
  State createState() {
    return _HomeState();
  }
}
class _HomeState extends State {
  Weather currentWeather;
  int _currentIndex = 0;
  final List _children = [
    HomeScreen(),
    Location(),
    Settings()
  ];
  List currentApp;
  void initState() {
    super.initState();
    currentWeather = Provider.of<WeatherViewModel>(context, listen: false).weather;
  }
  createAppBar() {
    currentApp  = [
      AppBar(
        title: const Text('Weather Forecast'),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showSearch(context: context, delegate: CustomSearchDelegate());
                },
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )
          ),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    addWeatherToSF(Provider.of<WeatherViewModel>(context, listen: false).weather);
                  });
                },
                child: Icon(
                    Icons.add_location
                ),
              )
          ),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  onTabTapped(0);
                },
                child: Icon(
                    Icons.refresh
                ),
              )
          ),
        ],
      ),
      AppBar(
        title: const Text('Weather Forecast'),
        centerTitle: true,
      ),
      AppBar(
        title: const Text('Weather Forecast'),
        centerTitle: true,
      )
    ];
  }

  void addWeatherToSF(Weather cw) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Fetch and decode data
    final String weatherString = prefs.getString('weatherData');
    List<Weather> weather;
    if (weatherString == null)
      weather =  [];
    else
      weather =  Weather.decode(weatherString);

    weather.add(cw);




    final String encodedData = Weather.encode(weather);

    setState(() {
      prefs.setString('weatherData', encodedData);
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("${cw.cityName} added"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    createAppBar();
    return Scaffold(
      appBar: currentApp[_currentIndex],
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            label: 'My Locations',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings'
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<WeatherViewModel>(context, listen: false)
          .searchWeatherData(location: query);
      close(context, "result");
    });
    return Column();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}
