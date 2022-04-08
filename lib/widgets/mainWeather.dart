import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../helper/utils.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../viewmodel/WeatherViewModel.dart';

class MainWeather extends StatelessWidget {
  final wData;

  MainWeather({this.wData});

  final TextStyle _style1 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 20,
  );
  final TextStyle _style2 = TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.grey[700],
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    int tempSwitch = Provider.of<WeatherViewModel>(context, listen: false).tempSwitch;

    return Container(
      padding: EdgeInsets.fromLTRB(25, 15, 25, 5),
      height: MediaQuery.of(context).size.height / 3.4,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on_outlined),
              Text('${wData.weather.cityName}, ${wData.weather.country}', style: _style1),
            ],
          ),

          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 25, right: 25),
                child: MapString.mapStringToIcon(
                    '${wData.weather.currently}', context, 55),
              ),
              Text(
                '${Provider.of<WeatherViewModel>(context, listen: false).tempTransform(wData.weather.temp)}°C',
                style: TextStyle(
                  fontSize: 55,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          ToggleSwitch(

            minWidth: 160,
            initialLabelIndex: tempSwitch,
            cornerRadius: 20.0,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            labels: ['Celsius', 'Fahrenheit'],
            activeBgColors: [[Colors.blue],[Colors.pink]],
            onToggle: (index)  {

              Provider.of<WeatherViewModel>(context, listen: false).switchTempFormat(index);

            },
          ),
        ],
      ),
    );
  }
}
