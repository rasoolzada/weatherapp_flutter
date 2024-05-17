import 'package:flutter/material.dart';
import 'package:weather_flutter_app/utilities/constants.dart';
import 'package:weather_flutter_app/services/weather.dart';
import 'package:weather_flutter_app/screens/city_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});
  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

WeatherModel weather = WeatherModel();
late int temprature;
late String weatherIcon;
late String cityName;
late String statusMessage;
String errorMessage = 'Unable to get weather data';
String weatherDescription = '';
late int weatherHumidity = 0;
late int windSpeed = 0;

class _LocationScreenState extends State<LocationScreen> {
  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temprature = 0;
        weatherIcon = 'Error';
        cityName = '';
        statusMessage = errorMessage;
        return;
      }
      double temp = weatherData['main']['temp'];
      temprature = temp.toInt();
      statusMessage = weather.getMessage(temprature);
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      cityName = weatherData['name'];
      weatherDescription = weatherData['weather'][0]['description'];
      weatherHumidity = weatherData['main']['humidity'];
      var wSpeed = weatherData['wind']['speed'];
      windSpeed = wSpeed.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CityScreen();
                          },
                        ),
                      );
                      if (typedName != null) {
                        var weatherData =
                            await weather.getCityWeather(typedName);
                        print(weatherData);
                        updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temprature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      ' $weatherIcon',
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, bottom: 20),
                child: Text(
                  '$weatherDescription',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, bottom: 20),
                child: Text('Humidity: $weatherHumidity%',
                    style: kParameterTextStyle),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, bottom: 20),
                child: Text(
                  'Wind Speed: $windSpeed km/h',
                  style: kParameterTextStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Text(
                  "$statusMessage \n in $cityName",
                  textAlign: TextAlign.center,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
