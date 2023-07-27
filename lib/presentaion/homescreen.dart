import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/constants/api_const.dart' as api_const;
import 'package:weather_app/presentaion/model/model.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  bool isloaded = false;
  String? cityname;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('getting location');
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
            visible: isloaded,
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
                            var postobject = Post();
                            print('Entering');
                            getcityWeather(postobject.cityname ?? '');
                            isloaded = true;
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
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade800,
                          offset: const Offset(1, 2),
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

  Future<Post> getcityWeather(String cityname) async {
    print('entered to city weather');
    final uri =
        Uri.parse("${api_const.baseUrl}?q=$cityname&appid=${api_const.apikey}");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        isloaded = true;
      });
      return Post.fromJson(jsonDecode(response.body));
    } else {
      print('no data found');
      throw Exception('Failed to load');
    }
  }

  Future<Post> getData() async {
    final uri =
        Uri.parse('${api_const.baseUrl}?q=$cityname&appid=${api_const.apikey}');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load');
    }
  }

  Future<Post> createPost(String title, String body) async {
    Map<String, dynamic> request = {
      'title': title,
      'body': body,
      'userid': '111'
    };
    final uri =
        Uri.parse('${api_const.baseUrl}?q=$cityname&appid=${api_const.apikey}');
    final response = await http.post(uri, body: request);
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load');
    }
  }
  // getCityWeather(String cityname) async {
  //   var client = http.Client();
  //   var uri = "${api_const.baseUrl}?q=$cityname&appid=${api_const.apikey}";
  //   var url = Uri.parse(uri);
  //   var response = await client.get(url);
  //   if (response.statusCode == 200) {
  //     var data = response.body;
  //     var decodeData = jsonDecode(data);
  //     print(data);
  //     updateUi(decodeData);
  //     setState(() {
  //       isLoaded = true;
  //     });
  //   } else {
  //     print(response.statusCode);
  //   }
  // }

  // getCurrentCityeather(Position position) async {
  //   var client = http.Client();
  //   var uri =
  //       "${api_const.baseUrl}?lat=${position.latitude}&lon=${position.longitude}&appid=${api_const.apikey}";
  //   var url = Uri.parse(uri);
  //   var response = await client.get(url);
  //   if (response.statusCode == 200) {
  //     var data = response.body;
  //     var decodeData = jsonDecode(data);
  //     print(data);
  //     updateUi(decodeData);
  //     setState(() {
  //       isLoaded = true;
  //     });
  //   } else {
  //     print(response.statusCode);
  //   }
  // }

  Future<Post> getcurrentcityWeather(Position position) async {
    print('entered to this currentcity function');
    final uri = Uri.parse(
        '${api_const.baseUrl}?lat=${position.latitude}&lon=${position.longitude}&appid=${api_const.apikey}');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        isloaded = true;
      });
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Faild to load the city weather');
    }
  }

  getCurrentLocation() async {
    print('getlocation');
    var p = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      forceAndroidLocationManager: true,
    );

    if (p != Null) {
      print('Lat: ${p.latitude},Long: ${p.longitude}');
      getcurrentcityWeather(p);
    } else {
      print('Location data not available');
    }
  }

  // updateUi(var decodeData) {
  //   setState(() {
  //     if (decodeData == null) {
  //       temperature = 0;
  //       pressure = 0;
  //       humidity = 0;
  //       cloudcover = 0;
  //       cityname = "Not Available";
  //     } else {
  //       temperature = decodeData['main']['temp'] - 273;
  //       pressure = decodeData['main']['pressure'];
  //       humidity = decodeData['main']['humidity'];
  //       cloudcover = decodeData['clouds']['all'];
  //       cityname = decodeData['name'];
  //     }
  //   });
  // }
}
