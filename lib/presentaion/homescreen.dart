import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/constants/api_const.dart' as api_const;

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  bool isLoaded = false;
  num? temperature;
  num? pressure;
  num? humidity;
  num? cloudcover;
  String? cityname;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0,
          title: const Text(
            'Weatherify',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 35, letterSpacing: 2),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff4158D0),
                Color(0xffC850C0),
                Color(0xffFFCC70),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Visibility(
            visible: isLoaded,
            replacement: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.07,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: TextFormField(
                        onFieldSubmitted: (String city) {
                          setState(() {
                            cityname = city;
                            getCityWeather(city);
                            isLoaded = false;
                          });
                        },
                        controller: controller,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                            letterSpacing: 1,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search City',
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 25,
                            color: Colors.white,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.pin_drop,
                        color: Colors.white70,
                        size: 35,
                      ),
                      Text(cityname ?? '',
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1),
                          overflow: TextOverflow.ellipsis)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.12,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade800,
                          offset: Offset(1, 2),
                          blurRadius: 2,
                          spreadRadius: 1,
                        )
                      ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getCityWeather(String cityname) async {
    var client = http.Client();
    var uri = "${api_const.baseUrl}?q=$cityname&appid=${api_const.apikey}";
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodeData = jsonDecode(data);
      print(data);
      updateUi(decodeData);
      setState(() {
        isLoaded = true;
      });
    } else {
      print(response.statusCode);
    }
  }

  getCurrentCityWeather(Position position) async {
    var client = http.Client();
    var uri =
        "${api_const.baseUrl}?lat=${position.latitude}&lon=${position.longitude}&appid=${api_const.apikey}";
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodeData = jsonDecode(data);
      print(data);
      updateUi(decodeData);
      setState(() {
        isLoaded = true;
      });
    } else {
      print(response.statusCode);
    }
  }

  getCurrentLocation() async {
    var p = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      forceAndroidLocationManager: true,
    );

    if (p != Null) {
      print('Lat: ${p.latitude},Long: ${p.longitude}');
      getCurrentCityWeather(p);
    } else {
      print('Location data not available');
    }
  }

  updateUi(var decodeData) {
    setState(() {
      if (decodeData == null) {
        temperature = 0;
        pressure = 0;
        humidity = 0;
        cloudcover = 0;
        cityname = "Not Available";
      } else {
        temperature = decodeData['main']['temp'] - 273;
        pressure = decodeData['main']['pressure'];
        humidity = decodeData['main']['humidity'];
        cloudcover = decodeData['clouds']['all'];
        cityname = decodeData['name'];
      }
    });
  }
}
