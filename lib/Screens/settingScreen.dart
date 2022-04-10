import 'package:flutter/material.dart';
import 'package:flutter_weather/viewmodel/WeatherViewModel.dart';

import 'package:provider/provider.dart';


class Settings extends StatefulWidget {
  static const routeName = '/settingsScreen';
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<Settings> {

  @override
  Widget build(BuildContext context) {

    final themeChange = Provider.of<WeatherViewModel>(context);

    return Scaffold(
      body: Container(
        child: Row (  children: [
          Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
          Text("Dark Mode",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),),

          Checkbox(
              value: themeChange.darkTheme,
              onChanged: (bool value) {
                themeChange.darkTheme = value;
              })
          ]
      ),
      )
    );
  }
}