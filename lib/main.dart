import 'package:flutter/material.dart';
import 'package:flutter_weather/Screens/homeScreen.dart';
import 'package:flutter_weather/Screens/locationScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './viewmodel/WeatherViewModel.dart';

import './Screens/navigationScreen.dart';
import 'Screens/settingScreen.dart';
import 'helper/TemperatureUnit.dart';
import 'themes/Styles.dart';

void main() {
  runApp(
    AppStateContainer(child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WeatherViewModel themeChangeProvider = new WeatherViewModel();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return
      ChangeNotifierProvider(
        create: (_) {
          return themeChangeProvider;
        },
        child: Consumer<WeatherViewModel>(
          builder: (BuildContext context, value, Widget child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: Styles.themeData(themeChangeProvider.darkTheme, context),
              home: Navigation(),
              routes:  <String, WidgetBuilder>{
                '/homeScreen': (context) => HomeScreen(),
                '/locationScreen': (context) => Location(),
                '/settingsScreen': (context) => Settings(),
              },
            );
          },
        ),);
  }
}

/// top level widget to hold application state
/// state is passed down with an inherited widget
/// inherited widget state is mainly used to hold app theme and temerature unit
class AppStateContainer extends StatefulWidget {
  final Widget child;

  AppStateContainer({@required this.child});

  @override
  _AppStateContainerState createState() => _AppStateContainerState();

  static _AppStateContainerState of(BuildContext context) {
    var widget =
    context.dependOnInheritedWidgetOfExactType<_InheritedStateContainer>();
    return widget.data;
  }
}

class _AppStateContainerState extends State<AppStateContainer> {

  TemperatureUnit temperatureUnit = TemperatureUnit.celsius;

  @override
  initState() {
    super.initState();
    SharedPreferences.getInstance().then((sharedPref) {
      setState(() {

        temperatureUnit = TemperatureUnit.values[
        sharedPref.getInt('temp_index') ??
            TemperatureUnit.celsius.index];

      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }


  updateTemperatureUnit(TemperatureUnit unit) {
    setState(() {
      this.temperatureUnit = unit;
    });
    SharedPreferences.getInstance().then((sharedPref) {
      sharedPref.setInt("temp_index", unit.index);
    });
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final _AppStateContainerState data;

  const _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer oldWidget) => true;
}
