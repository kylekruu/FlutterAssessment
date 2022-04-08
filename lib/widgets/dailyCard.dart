import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_weather/models/dailyWeather.dart';
import 'package:flutter_weather/models/weather.dart';
import 'package:intl/intl.dart';
import 'infoCard.dart';
import 'dart:developer';


class DailyCard extends StatelessWidget {
  final List<DailyWeather> data;//daily forecast data
  final Weather mainData;
  final bool imperial;
  final String unit;
  final kBorderRadius = BorderRadius.all(Radius.circular(14.0));
  final kDateTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.black54,
  );
  final kHourlyCardIcon = TextStyle(
    fontSize: 25.0,
  );

  DailyCard({this.data, this.imperial, this.unit, this.mainData});

  Widget dailyWidget(Weather weather, DailyWeather dw, BuildContext context) {
    //get the date of forecast and convert to human
    int offset = 0;
    DateTime forecastDate = dw.date;
    String weekDay = DateFormat('EEE').format(dw.date);

    //parse data
    int highTemp = weather.tempMax.round();
    int lowTemp = weather.tempMin.round();
    String icon = "0";
    String description = weather.description;

    return Flexible(child: Card(
        shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
        color: Colors.white,
        elevation: 1,
        child: ExpandablePanel(
      header: Container(
        padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
        width: 50.0,
        child: Center(
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            title: Text(
              description,
              style: TextStyle(
                  color: Colors.black
              ),
            ),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 55,
                  child: Center(
                    child: Text(
                      "${weekDay.substring(0, 3).toUpperCase()}",
                      style: kDateTextStyle.copyWith(color: Colors.black),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    icon,
                    style: kHourlyCardIcon,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  child: Center(
                    child: Text(
                      "${highTemp.toString()}°",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  width: 42,
                  child: Center(
                    child: Text(
                      "${lowTemp.toString()}°",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      expanded: buildExpanded(weather),
    )));
  }
  @override
  Widget build(BuildContext context) {
     return SingleChildScrollView(scrollDirection: Axis.vertical,
         child: ListView.builder(scrollDirection: Axis.vertical,
         shrinkWrap: true, itemCount: data.length,
            itemBuilder: (context, index) => this._buildRow(data[index], mainData)
        )
     );
  }
  _buildRow(DailyWeather dailyWeather,Weather weather) {
    String dateTxt = DateFormat('EEEE, MMMM dd, yyyy').format(dailyWeather.date);
    return ExpansionTile(
        childrenPadding: const EdgeInsets.all(8.0),
        title: Text(
          "$dateTxt",
        ),
        children: [
          Text(
            "Condition: ${dailyWeather.condition}",
          ),
          Text(
            "Temperature: ${dailyWeather.dailyTemp}",
          ),
        ] // Some list of List Tile's or widget of that kind,
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //
  //   return ExpandableNotifier(
  //     child: ScrollOnExpand(
  //       scrollOnCollapse: true,
  //       scrollOnExpand: true,
  //       child: Row(
  //
  //           children: data
  //               .map((item) => dailyWidget(mainData, item, context))
  //               .toList()),
  //     ),
  //   );
  // }



  Widget buildExpanded(dynamic data) {
    int offset = 0;

    double uvIndex = 0;

    int humidity = data.humidity?.round();

    int pressure = data.pressure?.round();



    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Center(
        child: GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          crossAxisCount: 3,
          children: [
            InfoCard(
              title: "sunrise",
              value: "",
            ),
            InfoCard(
              title: "sunset",
              value: "",
            ),
            InfoCard(
              title: "wind",
              value:
              "",
            ),
            InfoCard(
              title: "UVI",
              value: uvIndex.toString(),
            ),
            InfoCard(
              title: "humidity",
              value: "${humidity.toString()}%",
            ),
            InfoCard(
              title: "pressure",
              value: "${pressure.toString()} hPa",
            ),
          ],
        ),
      ),
    );
  }

}