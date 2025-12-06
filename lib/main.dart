import 'package:flutter/material.dart';
import 'package:kdgaugeview/kdgaugeview.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(Spmeter());
}

class Spmeter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Demo", home: Homepage());
  }
}

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() {
    return (Page1());
  }
}

class Page1 extends State<Homepage> {
  double s = 0; // initial Speed
  double a = 0; // initial altitude
  double h = 0; // initial heading
  bool isDark = true;

  @override
  void initState() {
    super.initState();
    startSpeedStream();
  }

  void startSpeedStream() async {
    LocationPermission permission = await Geolocator.requestPermission();

    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
      ),
    ).listen((Position position) {
      double speedMps = position.speed;
      double speedKmph = speedMps * 3.6;
      setState(() {
        s = speedKmph;
        a = position.altitude;
        h = position.heading;
      });
    });
  }

  String getDirection(double h) {
    if (h >= 337.5 || h < 22.5) return "N";
    if (h >= 22.5 && h < 67.5) return "NE";
    if (h >= 67.5 && h < 112.5) return "E";
    if (h >= 112.5 && h < 157.5) return "SE";
    if (h >= 157.5 && h < 202.5) return "S";
    if (h >= 202.5 && h < 247.5) return "SW";
    if (h >= 247.5 && h < 292.5) return "W";
    if (h >= 292.5 && h < 337.5) return "NW";
    return "";
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          "Speedometer",
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        actions: [
          Switch(
            value: isDark,
            onChanged: (value) {
              setState(() {
                isDark = value;
              });
            },
          ),
        ],
        backgroundColor: isDark ? Colors.black : Colors.white,
      ),

      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      //main container having kdGauge(Speedometer)
                      height: 300,
                      width: 300,
                      //color: Colors.grey,
                      child: Center(
                        child: KeyedSubtree(
                          key: ValueKey(s),
                          child: KdGaugeView(
                            minSpeed: 0,
                            maxSpeed: 330,
                            animate: true,
                            speed: s,
                            speedTextStyle: TextStyle(
                              fontSize: 40,
                              color:
                                  isDark
                                      ? Colors.white
                                      : Colors.black, //speed meter color
                            ),
                            unitOfMeasurementTextStyle: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color:
                                  isDark
                                      ? Colors.white
                                      : Colors.black, // color logic for KM/h
                            ),
                            duration: Duration(seconds: 0),
                            alertColorArray:
                                isDark
                                    ? [
                                      Colors.greenAccent,
                                      Colors.yellowAccent,
                                      Colors.orangeAccent,
                                      Colors.redAccent,
                                      Colors.purpleAccent,
                                    ]
                                    : [
                                      Colors.green,
                                      Colors.orange,
                                      Colors.deepOrange,
                                      Colors.red,
                                      Colors.purple,
                                    ],
                            alertSpeedArray: [0, 80, 120, 200, 300],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Container(
                      // left side box
                      width: 110,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(20),
                          right: Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.greenAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              "${a.toStringAsFixed(1)}m",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            "Altitude",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(45.0),
                    child: Container(
                      width: 110,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.greenAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        children: [
                          Transform.rotate(
                            angle: h * (3.14159 / 180), // convers degree
                            child: Icon(
                              Icons.arrow_upward,
                              size: 36,
                              //color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            "${getDirection(h)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              //color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Text(
              "Crafted by: \n\t\t\t\t\t\t\t\t\t\tSubham Roy",
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
