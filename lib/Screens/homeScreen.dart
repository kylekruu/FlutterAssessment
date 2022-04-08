import 'package:flutter/material.dart';
import 'package:flutter_weather/widgets/dailyCard.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../viewmodel/WeatherViewModel.dart';
import '../widgets/fadeIn.dart';
import '../widgets/hourlyForecast.dart';
import '../widgets/locationError.dart';
import '../widgets/mainWeather.dart';
import '../widgets/requestError.dart';


class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';
  const HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController();
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Future<void> _getData() async {
    _isLoading = true;
    final weatherData = Provider.of<WeatherViewModel>(context, listen: false);
    weatherData.getWeatherData();
    _isLoading = false;
  }

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<WeatherViewModel>(context, listen: false).getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    final weatherData = Provider.of<WeatherViewModel>(context);

    final myContext = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: myContext.primaryColor,
                ),
              )
            : weatherData.loading
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: myContext.primaryColor,
                    ),
                  )
                : weatherData.isLocationError
                    ? LocationError()
                    : Column(
                        children: [
                          weatherData.isRequestError
                              ? RequestError()
                              : Expanded(
                                  child: PageView(
                                    controller: _pageController,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        width: mediaQuery.size.width,
                                        child: RefreshIndicator(
                                          onRefresh: () =>
                                              _refreshData(context),
                                          backgroundColor: Colors.blue,
                                          child: ListView(
                                            children: [
                                              FadeIn(
                                                  delay: 0,
                                                  child: MainWeather(
                                                      wData: weatherData)),
                                              FadeIn(
                                                delay: 0.66,
                                                child: HourlyForecast(
                                                  wData: weatherData,
                                                  dWeather:
                                                  weatherData.sevenDayWeather,),
                                              ),
                                              FadeIn(
                                                delay: 0.66,
                                                child: DailyCard(
                                                  data: weatherData.sevenDayWeather,
                                                  imperial: true,
                                                  mainData: weatherData.weather),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                        ],
                      ),

      ),
    );

  }
}
